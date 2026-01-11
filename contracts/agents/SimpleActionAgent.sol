// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BaseAgent.sol";

/**
 * @title SimpleActionAgent
 * @notice Demonstrates payload decoding and state mutation
 */
contract SimpleActionAgent is BaseAgent {
    uint256 public executionCount;
    uint256 public lastValue;

    event AgentExecuted(
        uint256 executionCount,
        uint256 decodedValue
    );

    constructor(address _executor) BaseAgent(_executor) {}

    function execute(bytes calldata data)
        external
        override
        onlyExecutor
        returns (bool)
    {
        // Decode payload
        uint256 value = abi.decode(data, (uint256));

        executionCount += 1;
        lastValue = value;

        emit AgentExecuted(executionCount, value);

        return true;
    }
}
