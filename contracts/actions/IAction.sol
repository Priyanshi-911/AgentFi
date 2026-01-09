// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IAction
 * @notice Standard interface for all executable actions in Phase 2
 * @dev Actions are stateless execution units called by the ActionRouter
 */
interface IAction {
    /**
     * @notice Execute an action
     * @param data Encoded action-specific execution data
     * @return result Raw execution result data
     */
    function execute(bytes calldata data) external returns (bytes memory result);
}
