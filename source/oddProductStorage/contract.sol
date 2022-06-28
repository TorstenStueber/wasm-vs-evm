// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract Contract {
    event Result(int64 result);

    int64 value;
    int64 w;

    constructor() {
        value = 1;
        w = 1;
    }

    function setValue(int64 v) private {
        value = v;
    }

    function getValue() private returns (int64) {
        return value;
    }

    function oddProduct(
        int32 x,
        int32 writeFreq,
        int32 readFreq
    ) public {
        int64 prod = 1; // getValue();
        for (int32 counter = 1; counter <= x; counter++) {
            if (counter % writeFreq == 0) {
                setValue(prod);
            }

            if (counter % readFreq == 0) {
                unchecked {
                    prod *= (2 * counter - 1) * getValue();
                }
            } else {
                unchecked {
                    prod *= 2 * counter - 1;
                }
            }
        }

        emit Result(prod);
    }

    function oddStorage(int32 x, int32 writeFreq) public {
        int64 prod = 1; // getValue();
        for (int32 counter = 1; counter <= x; counter++) {
            if (counter % writeFreq == 0) {
                unchecked {
                    int64 t = prod * (2 * counter - 1) * value;
                    value = prod;
                    prod = t;
                }
            } else {
                int64 t = value;
                value = prod;
                prod = t;
            }
        }

        emit Result(prod);
    }
}
