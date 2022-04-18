// Code based on sha crate
// see https://github.com/andydude/rust-sha/

#![cfg_attr(not(feature = "std"), no_std)]

use ink_lang as ink;

fn hash(data: &mut [u8], data_length: usize, state: &mut [u64; 8]) {
    *state = H;

    let mut padding = 128 - (data_length % 128);
    if padding < 17 {
        padding += 128;
    }

    let new_length = data_length + padding;
    let bit_length = data_length * 8;

    data[data_length as usize] = 0x80;

    for (position, element) in data
        .iter_mut()
        .enumerate()
        .take(new_length as usize)
        .skip(data_length as usize + 1)
    {
        *element = if new_length - 1 - position < 8 {
            (bit_length as u64 >> ((new_length - 1 - position) * 8)) as u8
        } else {
            0
        };
    }

    for block_index in 0..new_length / 128 {
        digest_block(state, &data[block_index * 128..(block_index + 1) * 128]);
    }
}

/// TODO
pub const H: [u64; 8] = [
    0x6a09e667f3bcc908,
    0xbb67ae8584caa73b,
    0x3c6ef372fe94f82b,
    0xa54ff53a5f1d36f1,
    0x510e527fade682d1,
    0x9b05688c2b3e6c1f,
    0x1f83d9abfb41bd6b,
    0x5be0cd19137e2179,
];

/// TODO
pub const K: [u64; 80] = [
    0x428a2f98d728ae22,
    0x7137449123ef65cd,
    0xb5c0fbcfec4d3b2f,
    0xe9b5dba58189dbbc,
    0x3956c25bf348b538,
    0x59f111f1b605d019,
    0x923f82a4af194f9b,
    0xab1c5ed5da6d8118,
    0xd807aa98a3030242,
    0x12835b0145706fbe,
    0x243185be4ee4b28c,
    0x550c7dc3d5ffb4e2,
    0x72be5d74f27b896f,
    0x80deb1fe3b1696b1,
    0x9bdc06a725c71235,
    0xc19bf174cf692694,
    0xe49b69c19ef14ad2,
    0xefbe4786384f25e3,
    0x0fc19dc68b8cd5b5,
    0x240ca1cc77ac9c65,
    0x2de92c6f592b0275,
    0x4a7484aa6ea6e483,
    0x5cb0a9dcbd41fbd4,
    0x76f988da831153b5,
    0x983e5152ee66dfab,
    0xa831c66d2db43210,
    0xb00327c898fb213f,
    0xbf597fc7beef0ee4,
    0xc6e00bf33da88fc2,
    0xd5a79147930aa725,
    0x06ca6351e003826f,
    0x142929670a0e6e70,
    0x27b70a8546d22ffc,
    0x2e1b21385c26c926,
    0x4d2c6dfc5ac42aed,
    0x53380d139d95b3df,
    0x650a73548baf63de,
    0x766a0abb3c77b2a8,
    0x81c2c92e47edaee6,
    0x92722c851482353b,
    0xa2bfe8a14cf10364,
    0xa81a664bbc423001,
    0xc24b8b70d0f89791,
    0xc76c51a30654be30,
    0xd192e819d6ef5218,
    0xd69906245565a910,
    0xf40e35855771202a,
    0x106aa07032bbd1b8,
    0x19a4c116b8d2d0c8,
    0x1e376c085141ab53,
    0x2748774cdf8eeb99,
    0x34b0bcb5e19b48a8,
    0x391c0cb3c5c95a63,
    0x4ed8aa4ae3418acb,
    0x5b9cca4f7763e373,
    0x682e6ff3d6b2b8a3,
    0x748f82ee5defb2fc,
    0x78a5636f43172f60,
    0x84c87814a1f0ab72,
    0x8cc702081a6439ec,
    0x90befffa23631e28,
    0xa4506cebde82bde9,
    0xbef9a3f7b2c67915,
    0xc67178f2e372532b,
    0xca273eceea26619c,
    0xd186b8c721c0c207,
    0xeada7dd6cde0eb1e,
    0xf57d4f7fee6ed178,
    0x06f067aa72176fba,
    0x0a637dc5a2c898a6,
    0x113f9804bef90dae,
    0x1b710b35131c471b,
    0x28db77f523047d84,
    0x32caab7b40c72493,
    0x3c9ebe0a15c9bebc,
    0x431d67c49c100d4c,
    0x4cc5d4becb3e42b6,
    0x597f299cfc657e2a,
    0x5fcb6fab3ad6faec,
    0x6c44198c4a475817,
];

macro_rules! rotate_right {
    ($a:expr, $b:expr) => {
        ($a >> $b) ^ ($a << (64 - $b))
    };
}
macro_rules! sigma0 {
    ($a:expr) => {
        rotate_right!($a, 1) ^ rotate_right!($a, 8) ^ ($a >> 7)
    };
}
macro_rules! sigma1 {
    ($a:expr) => {
        rotate_right!($a, 19) ^ rotate_right!($a, 61) ^ ($a >> 6)
    };
}
macro_rules! big_sigma0 {
    ($a:expr) => {
        rotate_right!($a, 28) ^ rotate_right!($a, 34) ^ rotate_right!($a, 39)
    };
}
macro_rules! big_sigma1 {
    ($a:expr) => {
        rotate_right!($a, 14) ^ rotate_right!($a, 18) ^ rotate_right!($a, 41)
    };
}
macro_rules! bool3ary_202 {
    ($a:expr, $b:expr, $c:expr) => {
        $c ^ ($a & ($b ^ $c))
    };
}
macro_rules! bool3ary_232 {
    ($a:expr, $b:expr, $c:expr) => {
        ($a & $b) ^ ($a & $c) ^ ($b & $c)
    };
}

macro_rules! sha512_expand_round {
    ($work:expr, $t:expr) => {{
        let w = $work[($t + 0) & 15]
            .wrapping_add(sigma1!($work[($t + 14) & 15]))
            .wrapping_add(sigma0!($work[($t + 1) & 15]))
            .wrapping_add($work[($t + 9) & 15]);
        $work[($t + 0) & 15] = w;
        w
    }};
}

macro_rules! sha512_digest_round {
    ($a:ident, $b:ident, $c:ident, $d:ident,
        $e:ident, $f:ident, $g:ident, $h:ident,
        $k:expr, $w:expr) => {{
        $h = $h
            .wrapping_add($k)
            .wrapping_add($w)
            .wrapping_add(big_sigma1!($e))
            .wrapping_add(bool3ary_202!($e, $f, $g));
        $d = $d.wrapping_add($h);
        $h = $h
            .wrapping_add(big_sigma0!($a))
            .wrapping_add(bool3ary_232!($a, $b, $c));
    }};
}

/// There are no plans for hardware implementations at this time,
/// but this function can be easily implemented with some kind of
/// SIMD assistance.
///
/// ```ignore
/// {
///     // this is the core expression
///     let temp = sha512load(work[4], work[5]);
///     sha512msg(work[0], work[1], temp, work[7]);
/// }
/// ```
#[inline]
pub fn expand_round_x4(w: &mut [u64; 16], t: usize) {
    sha512_expand_round!(w, t);
    sha512_expand_round!(w, t + 1);
    sha512_expand_round!(w, t + 2);
    sha512_expand_round!(w, t + 3);
}

/// There are no plans for hardware implementations at this time,
/// but this function can be easily implemented with some kind of
/// SIMD assistance.
///
/// ```ignore
/// {
///     // this is to illustrate the data order
///     let ae = u64x2(a, e);
///     let bf = u64x2(b, f);
///     let cg = u64x2(c, g);
///     let dh = u64x2(d, h);
///
///     // this is the core expression
///     dh = sha512rnd(dh, ae, bf, cg, work[0]);
///     cg = sha512rnd(cg, dh, ae, bf, work[1]);
///     bf = sha512rnd(bf, cg, dh, ae, work[2]);
///     ae = sha512rnd(ae, bf, cg, dh, work[3]);
///
///     a = ae.0;
///     b = bf.0;
///     c = cg.0;
///     d = dh.0;
///     e = ae.1;
///     f = bf.1;
///     g = cg.1;
///     h = dh.1;
/// }
/// ```
#[inline]
pub fn digest_round_x4(state: &mut [u64; 8], k: [u64; 4], w: [u64; 4]) {
    let mut a = state[0];
    let mut b = state[1];
    let mut c = state[2];
    let mut d = state[3];
    let mut e = state[4];
    let mut f = state[5];
    let mut g = state[6];
    let mut h = state[7];
    sha512_digest_round!(a, b, c, d, e, f, g, h, k[0], w[0]);
    sha512_digest_round!(h, a, b, c, d, e, f, g, k[1], w[1]);
    sha512_digest_round!(g, h, a, b, c, d, e, f, k[2], w[2]);
    sha512_digest_round!(f, g, h, a, b, c, d, e, k[3], w[3]);
    *state = [e, f, g, h, a, b, c, d];
}

/// TODO
#[inline]
pub fn expand_round_x16(w: &mut [u64; 16]) {
    expand_round_x4(w, 0);
    expand_round_x4(w, 4);
    expand_round_x4(w, 8);
    expand_round_x4(w, 12);
}

/// TODO
#[inline]
pub fn digest_round_x16(state: &mut [u64; 8], k: [u64; 16], w: [u64; 16]) {
    macro_rules! as_simd {
        ($x:expr) => {{
            let (y, _): (&[u64; 4], usize) = unsafe { ::core::mem::transmute($x) };
            *y
        }};
    }

    digest_round_x4(state, as_simd!(&k[0..4]), as_simd!(&w[0..4]));
    digest_round_x4(state, as_simd!(&k[4..8]), as_simd!(&w[4..8]));
    digest_round_x4(state, as_simd!(&k[8..12]), as_simd!(&w[8..12]));
    digest_round_x4(state, as_simd!(&k[12..16]), as_simd!(&w[12..16]));
}

pub unsafe fn swap_memory(dst: *mut u8, src: *const u8, len: usize) {
    let (mut d, mut s) = (dst, src);
    for _ in 0..len {
        *(d.offset(0)) = *(s.offset(7));
        *(d.offset(1)) = *(s.offset(6));
        *(d.offset(2)) = *(s.offset(5));
        *(d.offset(3)) = *(s.offset(4));
        *(d.offset(4)) = *(s.offset(3));
        *(d.offset(5)) = *(s.offset(2));
        *(d.offset(6)) = *(s.offset(1));
        *(d.offset(7)) = *(s.offset(0));
        d = d.offset(8);
        s = s.offset(8);
    }
}

/// TODO
pub fn digest_block(state: &mut [u64; 8], buf: &[u8]) {
    use core::mem::transmute;
    let state2 = *state;
    let mut w: [u64; 16] = [0; 16];

    macro_rules! as_simd_array {
        ($x:expr) => {{
            let (y, _): (&[u64; 16], usize) = unsafe { transmute($x) };
            *y
        }};
    }

    unsafe {
        swap_memory((&mut w[..]).as_mut_ptr() as *mut u8, buf.as_ptr(), 16);
    }
    digest_round_x16(state, as_simd_array!(&K[0..16]), w);
    expand_round_x16(&mut w);
    digest_round_x16(state, as_simd_array!(&K[16..32]), w);
    expand_round_x16(&mut w);
    digest_round_x16(state, as_simd_array!(&K[32..48]), w);
    expand_round_x16(&mut w);
    digest_round_x16(state, as_simd_array!(&K[48..64]), w);
    expand_round_x16(&mut w);
    digest_round_x16(state, as_simd_array!(&K[64..80]), w);

    for i in 0..8 {
        state[i] = state[i].wrapping_add(state2[i]);
    }
}

pub fn iterated_hashes(n: u8, iterations: u32) -> u64 {
    let mut data = [0u8; 256];
    data[0] = n as u8;
    let mut result = [0u64; 8];

    hash(&mut data, 1, &mut result);

    for _ in 0..=iterations {
        for cell in 0..8 {
            let content = result[cell];
            data[(cell << 3) + 0] = (content >> 56) as u8;
            data[(cell << 3) + 1] = (content >> 48) as u8;
            data[(cell << 3) + 2] = (content >> 40) as u8;
            data[(cell << 3) + 3] = (content >> 32) as u8;
            data[(cell << 3) + 4] = (content >> 24) as u8;
            data[(cell << 3) + 5] = (content >> 16) as u8;
            data[(cell << 3) + 6] = (content >> 8) as u8;
            data[(cell << 3) + 7] = (content >> 0) as u8;
        }

        hash(&mut data, 64, &mut result);
    }

    let r = result[0];
    let r0 = (r >> 56) & 0xff;
    let r1 = (r >> 48) & 0xff;
    let r2 = (r >> 40) & 0xff;
    let r3 = (r >> 32) & 0xff;
    let r4 = (r >> 24) & 0xff;
    let r5 = (r >> 16) & 0xff;
    let r6 = (r >> 8) & 0xff;
    let r7 = (r >> 0) & 0xff;

    r0 + (r1 << 8) + (r2 << 16) + (r3 << 24) + (r4 << 32) + (r5 << 40) + (r6 << 48) + (r7 << 56)
}

#[ink::contract]
mod contract {
    #[ink(storage)]
    pub struct Sha512 {}

    impl Sha512 {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        fn compute(n: i32, repeat: i32) -> i64 {
            super::iterated_hashes(n as u8, repeat as u32) as i64
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the immutable version
        #[ink(message)]
        pub fn sha_512(&self, n: i32, repeat: i32) -> i64 {
            Self::compute(n, repeat)
        }

        /// Compute the product of the first `n` odd numbers.
        /// This is the mutable version
        #[ink(message)]
        pub fn sha_512_mut(&mut self, n: i32, repeat: i32) -> i64 {
            Self::compute(n, repeat)
        }
    }
}
