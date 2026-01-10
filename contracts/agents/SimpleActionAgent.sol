// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BaseAgent.sol";

/**
 * @title SimpleActionAgent
 * @notice Minimal concrete agent proving end-to-end execution.
 *         Tracks execution count and emits execution events.
 */
contract SimpleActionAgent is BaseAgent {
    /// @notice Number of times the agent has been executed
    uint256 public executionCount;

    /// @notice Emitted on successful agent execution
    event AgentExecuted(
        address indexed executor,
        uint256 executionCount,
        bytes payload
    );

    /**
     * @param _executor Address of the AgentExecutor contract
     */
    constructor(address _executor) BaseAgent(_executor) {}

    /**
     * @inheritdoc BaseAgent
     */
    function execute(bytes calldata data)
        external
        override
        onlyExecutor
        returns (bool success)
    {
        executionCount += 1;

        emit AgentExecuted(msg.sender, executionCount, data);

        return true;
    }
}
