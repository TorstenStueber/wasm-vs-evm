# Wasm vs EVM Benchmarking Tool

This is a tool to compile smart contracts for benchmarking purposes.

## How to Use

This repository contains a selection of benchmarking projects. Each project contains a particular function implemented in different kind of smart contracts languages.

This tool is to be used as follows:

- compile all smart contracts to their respective targets
- after that use the compiled smart contracts to run benchmarks

## Required Tools

- nodejs and npm
- rust and cargo
- [`cargo contract` CLI](https://github.com/paritytech/cargo-contract)
- [Solang](https://github.com/hyperledger-labs/solang)

## How to Compile

- first `npm install`
- create a file `config.json` in the root folder with the following content

  ```json
  {
    "pathToSolang": "relative/or/absolute/path/to/solang/binary"
  }
  ```

- then select one of the projects and run either one of the commands
  - `npm run build-odd-product`
  - `npm run build-triangle`
  - `npm run build-sha512`

Be aware that this will take a couple of minutes. The script will also show the size of the compiled smart contracts. All files will be compiled with highest optimization settings.

## Project

This repository contains three benchmarking projects

- `triangleNumbers`: compute the triangle number of `n`, i.e., the sum of all numbers 1 <= i <= n
- `oddProduct`: compute the product of the first `n` odd numbers
- `sha512`: compute the iterated SHA-512 for a given input; the source files avoid the use of standard library functions and use direct implementations of SHA-512 instead

Every project contains the following 6 files:

- `baseline.js`: a pure JavaScript implementation of the function
- `baseline.rs`: a pure Rust implementation of the function
- `contract.rs`: the ink! version of the smart contract
- `contract.sol`: the Solidity version of the smart contract
- `contract.wat`: the direct implementation of the smart contract in Wasm text format
- `pallet.rs`: a Substrate pallet version of the function

The project files will be compiled as follows (these files will be generated in the `build` folder):

- `baseline`: the compiled executable of `baseline.js`
- `baseline.js`: just a copy of the verbatim `baseline.js` code
- `ink.contract`: the compiled ink! smart contract with metadata, usable for pallet-contracts
- `solidity.contract`: the Solidity smart contract compiled to Wasm via Solang, usable for pallet-contracts
- `wat.contract`: the compiled Wasm text format smart contract from `contract.wat`, usable for pallet-contracts
- `pallet-chain`: a compiled standalone Substrate node that contains the pallet from `pallet.rs`
- `solidity.evm`: the Solidity smart contract compiled to EVM byte code, usable for Ethereum nodes or pallet-evm

The purpose of the baseline files is to compare the execution time of the contracts to natively executed Rust or JavaScript code

## How to Benchmark

This section describes how to run the benchmarks using the compiled contracts and chains.

### Wat Contract in Contracts Pallet

- start a local Substrate node with pallet-contracts in `--dev` mode
  - the node needs to implement pallet-contracts and its RPC API, e.g. the [node template with pallet-contracts](https://github.com/paritytech/substrate-contracts-node)
- launch [Polkadot UI](https://polkadot.js.org/apps) and connect to local node
- go to Developer -> Contracts and click on "Upload & deploy code"
- select the compiled file `wat.contract`
  - use "ALICE" as deployment account
  - then click "Next", then "Deploy", then "Sign and Submit"
- select the contract and send a message
  - it needs to be an `exec` message, i.e., the contract needs be executed on chain
  - wait for the estimated gas to be shown in the field "max gas allowed"
- once the message is processed, check the log output of the node
  - the line starting with `Prepared block for proposing` of the according block will show the processing time in ms

### Ink Contract in Contracts Pallet

- same as for the wat contract but use the contract file `ink.contract`

### Solidity Contract in Contracts Pallet

- same as for the wat contract but use the contract file `solidity.contract`

### Solidity Contract in EVM Pallet

- run a local Substrate chain with pallets-evm
  - fork all of frontier https://github.com/paritytech/frontier.git
  - go to `template` folder
  - inside run `cargo build --features=runtime-benchmarks --release`
  - on the main frontier main folder run `./target/release/frontier-template-node --dev`
- launch [Polkadot UI](https://polkadot.js.org/apps) and connect to local node
  - add [developer configuration for EVM](https://docs.substrate.io/tutorials/v3/frontier/#build--config-setup)
- go to Developer → Extrinsics and select the extrinisic `evm` → `create` and enter
  - source: `0xd43593c715fdd31c61141abd04a99fd6822c8558` (Alice's Ethereum address)
  - init: copy the compiled contract found inside the file `solidity.evm` (the complete line starting with `0x`)
  - value: 0
  - gasLimit and maxFeePerGas: 4294967295
  - remove items from the accessList at the end
  - submit the transaction
- immediately go to Network -> Chain info and locate the block that contained the contract creation
  - it will be a block containing an `evm.Created` event
  - open the event and _note down the H160 address_ (this is the Ethereum address of the contract)
- go to Developer → Extrinsics and select `evm` → `call` and specify
  - source: `0xd43593c715fdd31c61141abd04a99fd6822c8558` (Alice's Ethereum address)
  - target: the address of the contract (see above)
  - input: a hex value encoding the input to the call using the [Solidity ABI](https://docs.soliditylang.org/en/latest/abi-spec.html)
    - prefix with `0x`
    - concat the [function selector](https://www.notion.so/Setup-a-Frontier-Project-f38907147f9f4d50ba596000b05310d4)
      - find this function selector in the file `solidity.evm`
    - add arguments
      - if they are fixed size, then one argument after another
      - addresses are `uint160`
      - any `uint<M>` or `int<M>` is left padded so that it has 32 bytes (with `00` when nonnegative or with `ff` when negative)
  - value: 0
  - gasLimit and maxFeePerGas: 4294967295
  - remove items from the accessList at the end
  - submit the transaction
- once the transaction is processed, check the log output of the node
  - the line starting with `Prepared block for proposing` of the according block will show the processing time in ms

### Solidity Contract in Geth

- first compile a local Geth configured with much higher gas limits
  - install Go
  - clone `https://github.com/ethereum/go-ethereum.git`
  - make some changes to the standard configuration
    - edit `eth/ethconfig/config.go` and change `Defaults` config
      - change `RPCGasCap` to `5000000000`
      - change `RPCTxFeeCap` to `1000`
  - run `make geth`
- start geth in local development mode
  - go to the root folder of the cloned repository
  - if there is a folder `data`, remove it
  - run
    ```
    ./build/bin/geth --datadir data --http --dev --dev.gaslimit 1000000000 --http.corsdomain "https://remix.ethereum.org,http://remix.ethereum.org"
    ```
- take note of the log line “HTTP server started” and note the endpoint
  - it is probably `127.0.0.1:8545`
- in browser go to [Remix IDE](https://remix.ethereum.org/)
- in the side bar go to “File explorers” icon
  - in file tree open folder “contract” and add a new file `contract.sol`
  - paste the solidity contract `contract.sol` from the project source folder
- in the side bar go to “Solidity compiler” icon
  - select the compiler version matching the version of `solc` npm package in `package.json` (no nightly version)
  - select EVM version "london"
  - enable optimization with 200 runs
  - then click button “Compile contract.sol”
  - if required, click on the button “Compilation Details” and inspect details like BYTECODE → `object` for the generated bytecode or FUNCTIONHASHES for the selectors of the functions
- in the side bar go to “Deploy & run transactions” icon
  - in ENVIRONMENT select “Web 3 Provider”
    - in the popup ensure that the “Web3 Provider Endpoint” is the http server of the local geth node (see above)
    - confirm the popup
  - in the CONTRACT pulldown ensure that the compiled contract is selected
  - click “Deploy”
    - the local Geth node should mine a new block
  - the deployed contract will now appear under "Deplozed Contracts"
    - open it
    - select a function, enter the input values and click the button with the name of the function
      - the local node will mine a new block
    - in the console line starting `Commit new sealing work` there is a field `elapsed` that describes the time passed and the field `gas` describes the gas payed

### Substrate Pallet

- the compiled file `pallet-chain` is a complete standalone substrate node containing the pallet
- the substrate pallet can be executed through the wasm (i.e., it will run through a Wasm engine) or through the native executor (i.e., the native compiled code will be executed)
- execute either one of the following commands to start the node:
  ```
  ./pallet-chain --execution Wasm --dev
  ./pallet-chain --execution Native --dev
  ```
- launch [Polkadot UI](https://polkadot.js.org/apps) and connect to local node
- go to Developer -> Extrinsics and and select `templateModule` and select the function to call
- select the compiled file `wat.contract`
  - enter the required input values
  - submit the transaction
- once the transaction is processed, check the log output of the node
  - the line starting with `Prepared block for proposing` of the according block will show the processing time in ms

### JavaScript Baseline

- go to the `build` folder and to the project subfolder
- run `node baseline.js` and add any required command line arguments

### Rust Baseline

- go to the `build` folder and to the project subfolder
- run `./baseline` and add any required command line arguments
