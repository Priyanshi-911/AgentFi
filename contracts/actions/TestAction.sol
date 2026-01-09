// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IAction } from "./IAction.sol";

contract TestAction is IAction {
    event Executed(bytes data);

    function execute(bytes calldata data) external returns (bytes memory) {
        emit Executed(data);
        return data;
    }
}
