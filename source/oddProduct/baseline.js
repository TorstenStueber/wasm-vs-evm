const REPEATS = 100;
const n = Number(process.argv[2]);

const now = Date.now();

let repeat = REPEATS;

while (repeat--) {
  let product = 1;
  for (let i = 1; i <= n; i++) {
    product = (product * (2 * i - 1)) & 0xffffffff;
  }

  if (repeat == 0) {
    console.log(`Result: ${product < 0 ? product + 2 ** 32 : product}`);
  }
}

console.log(`Used time (average, in ms): ${(Date.now() - now) / REPEATS}`);
