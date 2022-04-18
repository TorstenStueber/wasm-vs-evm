const REPEATS = 100;
const n = Number(process.argv[2]);

const now = Date.now();

let repeat = REPEATS;

while (repeat--) {
  let sum = 0;
  for (let i = 1; i <= n; i++) {
    sum += i;
  }

  if (repeat == 0) {
    console.log(`Result: ${sum}`);
  }
}

console.log(`Used time (average, in ms): ${(Date.now() - now) / REPEATS}`);
