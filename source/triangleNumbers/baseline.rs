use std::time::Instant;

pub fn triangle_number(n: u32) -> u64 {
    (1..=n as u64).fold(0, |sum, x| sum.wrapping_add(x))
}

const REPEAT: u128 = 1000;

fn main() {
    let args: Vec<String> = std::env::args().collect();

    let n: u32 = args[1].parse().unwrap();
    let now = Instant::now();

    let mut a = 0;

    for _ in 0..REPEAT {
        a = triangle_number(n)
    }

    println!(
        "Result: {},\nUsed time (average, in milliseconds): {}",
        a,
        (now.elapsed().as_nanos() / REPEAT) as f32 / 1_000_000.0
    );
}
