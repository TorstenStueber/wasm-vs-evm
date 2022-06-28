#![cfg_attr(not(feature = "std"), no_std)]

use ink_lang as ink;

#[ink::contract]
mod contract {
    #[ink(storage)]
    pub struct OddProduct {
        value: i64,
    }

    impl OddProduct {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self { value: 1 }
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the mutable version
        #[ink(message)]
        pub fn odd_product_mut(&mut self, n: i32, write_freq: i64, read_freq: i64) -> i64 {
            (1..=n as i64).fold(1, |prod, x| {
                if x % write_freq == 0 {
                    self.value = prod;
                }

                if x % read_freq == 0 {
                    prod.wrapping_mul(2 * x - 1).wrapping_mul(self.value)
                } else {
                    prod.wrapping_mul(2 * x - 1)
                }
            })
        }

        #[ink(message)]
        pub fn storage_mut(&mut self, n: i32, write_freq: i64) -> i64 {
            (1..=n as i64).fold(1, |prod, x| {
                let r = if x % write_freq == 0 {
                    prod.wrapping_mul(2 * x - 1).wrapping_mul(self.value)
                } else {
                    self.value
                };

                self.value = prod;
                r
            })
        }
    }
}
