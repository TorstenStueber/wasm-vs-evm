// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract Contract {
    event Result(int64 result);

    function oddProduct(int32 x) public {
        int64 prod = 1;
        for (int32 counter = 1; counter <= x; counter++) {
            unchecked {
                prod *= 2 * counter - 1;
            }
        }

        emit Result(prod);
    }
}
