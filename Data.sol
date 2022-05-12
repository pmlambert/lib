// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24;

library Data {
    /// @dev the storage key where the amendment address is kept.
    bytes32 private constant AMENDMENT_KEY = keccak256("AMENDMENT_KEY");
    /// @dev struct to hold amendment address in memory to prevent multiple state reads.
    struct Amendment {
        address amendment;
    }
    /// @dev call this once and pass the returned value when reading to save 100 gas per read.
    function init() internal view returns (Amendment memory amendment) {
        bytes32 KEY = AMENDMENT_KEY;
        assembly {
            mstore(amendment, sload(KEY))
        }
    }
    /// @dev read from the amendment at `key` word index.
    function read(Amendment memory amendment, uint16 key) internal view returns (bytes32 value) {
        assembly {
            extcodecopy(mload(amendment), 0, mul(key, 32), 32)
            value := mload(0)
        }
    }
    /// @dev read a range of values.
    function readRange(Amendment memory amendment, uint16 start, uint16 length) internal view returns (bytes32[] memory values) {
        assembly {
            let values := mload(0x40)
            let len := mul(length, 32)
            let data := add(values, 1)
            extcodecopy(mload(amendment), data, mul(start, 32), len)
            mstore(0x40, add(data, len))
        }
    }
    /// @dev create a new amendment.
    /// @dev `values` must be a standard array created with new bytes32[](len).
    /// @dev recommended to replace the `init` return value with this one.
    function amend(bytes32[] memory values) internal returns (Amendment memory amendment) {
        bytes32 KEY = AMENDMENT_KEY;
        assembly {
            let len := mload(values)
            mstore(values, 0x000000000000000000000000000000000000000000600b8038038091363936f3)
            mstore(amendment, create(0, add(values, 21), add(len, 11)))
            mstore(values, len)
            sstore(KEY, mload(amendment))
        }
    }
}
