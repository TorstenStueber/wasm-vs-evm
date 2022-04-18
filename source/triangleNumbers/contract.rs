#![cfg_attr(not(feature = "std"), no_std)]

use ink_lang as ink;

#[ink::contract]
mod contract {
    #[ink(storage)]
    pub struct TriangleNumber {}

    impl TriangleNumber {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        fn compute(n: i32) -> i64 {
            (1..=n as i64).fold(0, |sum, x| sum.wrapping_add(x))
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the immutable version
        #[ink(message)]
        pub fn triangle_number(&self, n: i32) -> i64 {
            Self::compute(n)
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the mutable version
        #[ink(message)]
        pub fn triangle_number_mut(&mut self, n: i32) -> i64 {
            Self::compute(n)
        }
    }
}
