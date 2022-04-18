import { join, resolve, basename } from "path";
import { accessSync, constants, copyFileSync, readFileSync, writeFileSync } from "fs";
import { spawn } from "child_process";
import wabt from "wabt";
import { blake2b } from "blakejs";
import * as solc from "solc";

try {
  const configFilePath = join(resolve(), "config.json");
  accessSync(configFilePath, constants.F_OK);
} catch {
  console.error("Please create a config.json file in the root folder");
  process.exit(1);
}

const config = JSON.parse(readFileSync(join(resolve(), "config.json")).toString());

const project = process.argv[2];
if (!project) {
  console.error("ERROR: need to specify a project");
  process.exit(1);
}

const buildFolder = join(resolve(), "build", project);
const tmpFolder = join(resolve(), "tmp");

main();

async function main() {
  try {
    await buildProject(join(resolve(), "source", project));
  } catch (error) {
    console.log("Error");
    console.error(error);
  }
}

async function buildProject(folder) {
  try {
    accessSync(folder, constants.F_OK);
    console.log(`Build project '${project}'`);
  } catch {
    console.error(`Project '${project}' does not exist`);
    process.exit(1);
  }

  await execute(`rm -rf build/${project}`, resolve());
  await execute(`mkdir -p build/${project}`, resolve());

  await execute("rm -rf tmp", resolve());
  await execute("mkdir tmp", resolve());

  let inkFile = join(folder, "contract.rs");
  let wasmFile = join(folder, "contract.wat");
  let solidityFile = join(folder, "contract.sol");
  let jsFile = join(folder, "baseline.js");
  let rustFile = join(folder, "baseline.rs");
  let palletFile = join(folder, "pallet.rs");

  try {
    accessSync(inkFile, constants.F_OK);
  } catch {
    inkFile = undefined;
  }

  try {
    accessSync(wasmFile, constants.F_OK);
  } catch {
    wasmFile = undefined;
  }

  try {
    accessSync(solidityFile, constants.F_OK);
  } catch {
    solidityFile = undefined;
  }

  try {
    accessSync(jsFile, constants.F_OK);
  } catch {
    jsFile = undefined;
  }

  try {
    accessSync(rustFile, constants.F_OK);
  } catch {
    rustFile = undefined;
  }

  try {
    accessSync(palletFile, constants.F_OK);
  } catch {
    palletFile = undefined;
  }

  if (inkFile) {
    const metadata = await inkToWasm(inkFile);
    if (wasmFile) {
      await watToWasm(wasmFile, metadata);
    }
  }

  if (solidityFile) {
    await solidityToWasm(solidityFile);
    await solidityToEvm(solidityFile);
  }

  if (jsFile) {
    await copyJsFile(jsFile);
  }

  if (rustFile) {
    await compileRustFile(rustFile);
  }

  if (palletFile) {
    await createPalletChain(palletFile);
  }

  await execute("rm -rf tmp", resolve());
}

async function inkToWasm(inkFile) {
  console.log("Compile ink to wasm");
  await execute("cargo contract new contract", tmpFolder);
  copyFileSync(inkFile, join(tmpFolder, "contract", "lib.rs"));
  await execute("cargo +nightly contract build --release --optimization-passes 4", join(tmpFolder, "contract"));
  const contract = JSON.parse(
    readFileSync(join(tmpFolder, "contract", "target", "ink", "contract.contract")).toString("utf-8")
  );
  copyFileSync(join(tmpFolder, "contract", "target", "ink", "contract.contract"), join(buildFolder, "ink.contract"));

  console.log(`  Contract length: ${contract.source.wasm.length / 2 - 1}`);
  return contract;
}

async function watToWasm(wasmFile, metadata) {
  console.log("Compile wat to wasm");

  const wat = readFileSync(wasmFile).toString("utf-8");
  const wasmModule = (await wabt()).parseWat(basename(wasmFile), wat);
  const wasmData = wasmModule.toBinary({ log: false }).buffer;

  const blake = blake2b(wasmData, undefined, 32);
  const blakeHex = Buffer.from(blake).toString("hex");

  metadata.source = {
    hash: `0x${blakeHex}`,
    language: "WASM",
    wasm: `0x${Buffer.from(wasmData).toString("hex")}`,
  };

  writeFileSync(join(buildFolder, "wat.contract"), JSON.stringify(metadata));
  console.log(`  Contract length: ${wasmData.length}`);
}

async function solidityToWasm(solidityFile) {
  console.log("Compile solidity to wasm");

  const { pathToSolang } = config;
  if (!pathToSolang) {
    throw new Error("Add field 'pathToSoland' to config.json with reference to your solang binary");
  }

  const solangPath = join(resolve(), pathToSolang).toString();
  await execute(
    `${solangPath.toString()} ${solidityFile.toString()} --target substrate -O aggressive -o tmp/solang`,
    resolve()
  );

  copyFileSync(join(tmpFolder, "solang", "Contract.contract"), join(buildFolder, "solidity.contract"));
  const contractFile = JSON.parse(readFileSync(join(tmpFolder, "solang", "Contract.contract")).toString());
  console.log(`  Contract length: ${contractFile.source.wasm.length / 2 - 1}`);
}

async function solidityToEvm(solidityFile) {
  console.log("Compile solidity to evm bytecode");

  const solidityContract = readFileSync(solidityFile).toString("utf-8");

  const input = {
    language: "Solidity",
    sources: {
      [basename(solidityContract)]: {
        content: solidityContract,
      },
    },
    settings: {
      outputSelection: {
        "*": {
          "*": ["*"],
        },
      },
      optimizer: { enabled: true, runs: 200 },
      evmVersion: "london",
    },
  };

  const output = JSON.parse(solc.default.compile(JSON.stringify(input)));
  const contracts = output.contracts[basename(solidityContract)];

  let result = "";

  Object.entries(contracts).forEach(([contractName, contract]) => {
    result += `${contractName}:\n`;
    result += `${contractName.replace(/./g, "=")}=\n`;
    result += `0x${contract.evm.bytecode.object}\n\n`;

    Object.entries(contract.evm.methodIdentifiers).forEach(([method, selector]) => {
      result += `- ${method}: ${selector}\n`;
    });

    console.log(`  Contract length: ${contract.evm.bytecode.object.length / 2}`);
  });

  writeFileSync(join(buildFolder, "solidity.evm"), result);
}

async function copyJsFile(jsFile) {
  console.log("Copy js file");

  copyFileSync(jsFile, join(buildFolder, "baseline.js"));
}

async function compileRustFile(rustFile) {
  console.log("Compile rust file");

  await execute("cargo new baseline", tmpFolder);
  copyFileSync(rustFile, join(tmpFolder, "baseline", "src", "main.rs"));
  await execute("cargo build -r", join(tmpFolder, "baseline"));
  copyFileSync(join(tmpFolder, "baseline", "target", "release", "baseline"), join(buildFolder, "baseline"));
}

async function createPalletChain(palletFile) {
  console.log("Create a chain with the pallet");

  await execute("git clone https://github.com/substrate-developer-hub/substrate-node-template.git chain", tmpFolder);
  const chainFolder = join(tmpFolder, "chain");
  await execute("git checkout 7c342164629e7871b4ee3f09de3d4e130bef6543", chainFolder);
  copyFileSync(palletFile, join(chainFolder, "pallets", "template", "src", "lib.rs"));

  await execute("cargo build --release", chainFolder);

  copyFileSync(join(chainFolder, "target", "release", "node-template"), join(buildFolder, "pallet-chain"));
}

async function execute(command, cwd) {
  return new Promise((resolve, reject) => {
    command = command.split(" ");
    const ls = spawn(command[0], command.slice(1), { cwd: cwd.toString() });

    let stderr = "";

    ls.stdout.on("data", (data) => {
      if (process.env.DEBUG) {
        process.stdout.write(data.toString());
      }
    });

    ls.stderr.on("data", (data) => {
      if (process.env.DEBUG) process.stderr.write(data.toString());
      stderr += data.toString();
    });

    ls.on("close", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(stderr);
      }
    });
  });
}
