// SPDX-License-Identifier:  UNLICENSED
pragma solidity >=0.4.24;

library OGSafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := add(x, y)
            if gt(x, z) { invalid() }
        }
    }
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := sub(x, y)
            if gt(z, x) { invalid() }
        }
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := mul(x, y)
            if iszero(or(x, eq(div(z, x), y))) { invalid() }
        }
    }
}
