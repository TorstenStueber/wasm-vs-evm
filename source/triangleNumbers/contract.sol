// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract Contract {
    event Result(int64 result);

    function triangleNumber(int32 x) public {
        int64 sum = 0;
        for (int32 counter = 1; counter <= x; counter++) {
            unchecked {
                sum += counter;
            }
        }

        emit Result(sum);
    }
}
