// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ValidationLib
 * @notice Common validation helpers for Phase 2 execution flow
 * @dev Contains only pure/view functions
 */
library ValidationLib {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error ZeroAddress();
    error EmptyData();
    error EmptyArray();
    error InvalidValue();

    /*//////////////////////////////////////////////////////////////
                            VALIDATIONS
    //////////////////////////////////////////////////////////////*/

    function ensureNonZero(address addr) internal pure {
        if (addr == address(0)) revert ZeroAddress();
    }

    function ensureNonEmpty(bytes memory data) internal pure {
        if (data.length == 0) revert EmptyData();
    }

    function ensureNonEmptyArray(uint256 length) internal pure {
        if (length == 0) revert EmptyArray();
    }

    function ensurePositive(uint256 value) internal pure {
        if (value == 0) revert InvalidValue();
    }
}
