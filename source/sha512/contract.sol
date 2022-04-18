// Code based on https://github.com/jindada1/SHA512

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Contract {
    event Result(int64 result);

    function SHA512(bytes1 n, uint32 iterations) public {
        bytes memory alloc = new bytes(256); // maximal required size of allocation in this function
        alloc[0] = n;
        uint64[8] memory result = [uint64(0), 0, 0, 0, 0, 0, 0, 0];
        uint64[16] memory M = [
            uint64(0),
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        ];
        uint64[80] memory W = [
            uint64(0),
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        ];

        uint64[80] memory K = [
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
            0x6c44198c4a475817
        ];

        hash(alloc, 1, result, M, W, K);

        for (uint32 i = 0; i <= iterations; i++) {
            for (uint8 cell = 0; cell < 8; cell++) {
                uint64 content = result[cell];
                alloc[(cell << 3) + 0] = bytes1(uint8(content >> 56));
                alloc[(cell << 3) + 1] = bytes1(uint8(content >> 48));
                alloc[(cell << 3) + 2] = bytes1(uint8(content >> 40));
                alloc[(cell << 3) + 3] = bytes1(uint8(content >> 32));
                alloc[(cell << 3) + 4] = bytes1(uint8(content >> 24));
                alloc[(cell << 3) + 5] = bytes1(uint8(content >> 16));
                alloc[(cell << 3) + 6] = bytes1(uint8(content >> 8));
                alloc[(cell << 3) + 7] = bytes1(uint8(content >> 0));
            }

            hash(alloc, 64, result, M, W, K);
        }

        uint64 r = result[0];
        uint64 r0 = (r >> 56) & 0xff;
        uint64 r1 = (r >> 48) & 0xff;
        uint64 r2 = (r >> 40) & 0xff;
        uint64 r3 = (r >> 32) & 0xff;
        uint64 r4 = (r >> 24) & 0xff;
        uint64 r5 = (r >> 16) & 0xff;
        uint64 r6 = (r >> 8) & 0xff;
        uint64 r7 = (r >> 0) & 0xff;

        r =
            r0 +
            (r1 << 8) +
            (r2 << 16) +
            (r3 << 24) +
            (r4 << 32) +
            (r5 << 40) +
            (r6 << 48) +
            (r7 << 56);
        emit Result(int64(r));
    }

    // @notice: The message, M, shall be padded before hash computation begins.
    //          The purpose of this padding is to ensure that the padded message is a multiple of 1024 bits.
    // @param message input raw message bytes
    // @return padded message bytes
    function preprocess(bytes memory message, uint256 dataLength)
        private
        pure
        returns (uint256)
    {
        uint256 padding = 128 - (dataLength % 128);
        if (padding < 17) padding += 128;
        uint256 newLength = dataLength + padding;

        message[dataLength] = 0x80;

        for (uint256 index = dataLength + 1; index < newLength; index++) {
            message[index] = 0x00;
        }

        uint128 bitSize = uint128(dataLength * 8);
        for (uint256 index = 0; index < 16; index++) {
            message[newLength - 1 - index] = bytes1(
                uint8((bitSize) >> (index * 8))
            );
        }

        return newLength;
    }

    function bytesToBytes8(bytes memory b, uint256 offset)
        private
        pure
        returns (uint64)
    {
        return
            (uint64(uint8(b[offset + 0])) << 56) +
            (uint64(uint8(b[offset + 1])) << 48) +
            (uint64(uint8(b[offset + 2])) << 40) +
            (uint64(uint8(b[offset + 3])) << 32) +
            (uint64(uint8(b[offset + 4])) << 24) +
            (uint64(uint8(b[offset + 5])) << 16) +
            (uint64(uint8(b[offset + 6])) << 8) +
            (uint64(uint8(b[offset + 7])) << 0);
    }

    function cutBlock(
        bytes memory data,
        uint256 blockIndex,
        uint64[16] memory M
    ) private pure {
        for (uint256 r = 0; r < 16; r++) {
            M[r] = bytesToBytes8(data, blockIndex * 128 + r * 8);
        }
    }

    // This section defines the functions that are used by sha-512.
    // https://csrc.nist.gov/csrc/media/publications/fips/180/2/archive/2002-08-01/documents/fips180-2.pdf#page=15

    // @notice: Thus, ROTR(x, n) is equivalent to a circular shift (rotation) of x by n positions to the right.
    // @param x input num
    // @param n num of positions to circular shift
    // @return uint64
    function ROTR(uint64 x, uint256 n) private pure returns (uint64) {
        return (x << uint64(64 - n)) + (x >> uint64(n));
    }

    // @notice: The right shift operation SHR n(x), where x is a w-bit word and n is an integer with 0 <= n < w, is defined by SHR(x, n) = x >> n.
    // @param x input num
    // @param n num of positions to shift
    // @return uint64
    function SHR(uint64 x, uint256 n) private pure returns (uint64) {
        return uint64(x >> n);
    }

    // @notice: Ch(x, y, z) = (x ^ y) ⊕ (﹁ x ^ z)
    // @param x x
    // @param y y
    // @param z z
    // @return uint64
    function Ch(
        uint64 x,
        uint64 y,
        uint64 z
    ) private pure returns (uint64) {
        return (x & y) ^ ((x ^ 0xffffffffffffffff) & z);
    }

    // @notice: Maj(x, y, z) = (x ^ y) ⊕ (x ^ z) ⊕ (y ^ z)
    // @param x x
    // @param y y
    // @param z z
    // @return uint64
    function Maj(
        uint64 x,
        uint64 y,
        uint64 z
    ) private pure returns (uint64) {
        return (x & y) ^ (x & z) ^ (y & z);
    }

    // @notice: sigma0(x) = ROTR(x, 28) ^ ROTR(x, 34) ^ ROTR(x, 39)
    // @param x x
    // @return uint64
    function sigma0(uint64 x) private pure returns (uint64) {
        return ROTR(x, 28) ^ ROTR(x, 34) ^ ROTR(x, 39);
    }

    // @notice: sigma1(x) = ROTR(x, 14) ^ ROTR(x, 18) ^ ROTR(x, 41)
    // @param x x
    // @return uint64
    function sigma1(uint64 x) private pure returns (uint64) {
        return ROTR(x, 14) ^ ROTR(x, 18) ^ ROTR(x, 41);
    }

    // @notice: gamma0(x) = OTR(x, 1) ^ ROTR(x, 8) ^ SHR(x, 7)
    // @param x x
    // @return uint64
    function gamma0(uint64 x) private pure returns (uint64) {
        return ROTR(x, 1) ^ ROTR(x, 8) ^ SHR(x, 7);
    }

    // @notice: gamma1(x) = ROTR(x, 19) ^ ROTR(x, 61) ^ SHR(x, 6)
    // @param x x
    // @return uint64
    function gamma1(uint64 x) private pure returns (uint64) {
        return ROTR(x, 19) ^ ROTR(x, 61) ^ SHR(x, 6);
    }

    // 工作变量
    struct FuncVar {
        uint64 a;
        uint64 b;
        uint64 c;
        uint64 d;
        uint64 e;
        uint64 f;
        uint64 g;
        uint64 h;
    }

    // @notice Calculate the SHA512 of input data.
    // @param data input data bytes
    // @return 512 bits hash result
    function hash(
        bytes memory data,
        uint256 dataLength,
        uint64[8] memory H,
        uint64[16] memory M,
        uint64[80] memory W,
        uint64[80] memory K
    ) private pure {
        unchecked {
            // 中间哈希

            H[0] = 0x6a09e667f3bcc908;
            H[1] = 0xbb67ae8584caa73b;
            H[2] = 0x3c6ef372fe94f82b;
            H[3] = 0xa54ff53a5f1d36f1;
            H[4] = 0x510e527fade682d1;
            H[5] = 0x9b05688c2b3e6c1f;
            H[6] = 0x1f83d9abfb41bd6b;
            H[7] = 0x5be0cd19137e2179;

            uint64 T1;
            uint64 T2;

            FuncVar memory fvar; // 工作变量

            // 补位，使其位长为 1024 bits 的整数倍，即 128 个 bytes
            uint256 paddedLength = preprocess(data, dataLength);

            // 处理每个 block
            for (uint256 j = 0; j < paddedLength / 128; j++) {
                cutBlock(data, j, M);

                fvar.a = H[0];
                fvar.b = H[1];
                fvar.c = H[2];
                fvar.d = H[3];
                fvar.e = H[4];
                fvar.f = H[5];
                fvar.g = H[6];
                fvar.h = H[7];

                // 迭代 80 轮
                for (uint256 i = 0; i < 80; i++) {
                    // 计算消息列表
                    if (i < 16) {
                        W[i] = M[i];
                    } else {
                        W[i] =
                            gamma1(W[i - 2]) +
                            W[i - 7] +
                            gamma0(W[i - 15]) +
                            W[i - 16];
                    }

                    T1 =
                        fvar.h +
                        sigma1(fvar.e) +
                        Ch(fvar.e, fvar.f, fvar.g) +
                        K[i] +
                        W[i];
                    T2 = sigma0(fvar.a) + Maj(fvar.a, fvar.b, fvar.c);

                    fvar.h = fvar.g;
                    fvar.g = fvar.f;
                    fvar.f = fvar.e;
                    fvar.e = fvar.d + T1;
                    fvar.d = fvar.c;
                    fvar.c = fvar.b;
                    fvar.b = fvar.a;
                    fvar.a = T1 + T2;
                }

                H[0] = H[0] + fvar.a;
                H[1] = H[1] + fvar.b;
                H[2] = H[2] + fvar.c;
                H[3] = H[3] + fvar.d;
                H[4] = H[4] + fvar.e;
                H[5] = H[5] + fvar.f;
                H[6] = H[6] + fvar.g;
                H[7] = H[7] + fvar.h;
            }
        }
    }
}
