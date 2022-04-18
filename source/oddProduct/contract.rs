#![cfg_attr(not(feature = "std"), no_std)]

use ink_lang as ink;

#[ink::contract]
mod contract {
    #[ink(storage)]
    pub struct OddProduct {}

    impl OddProduct {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        fn compute(n: i32) -> i64 {
            (1..=n as i64).fold(1, |prod, x| prod.wrapping_mul(2 * x - 1))
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the immutable version
        #[ink(message)]
        pub fn odd_product(&self, n: i32) -> i64 {
            Self::compute(n)
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the mutable version
        #[ink(message)]
        pub fn odd_product_mut(&mut self, n: i32) -> i64 {
            Self::compute(n)
        }
    }
}
