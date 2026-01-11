// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/AgentExecutor.sol";

/**
 * @title AutomationController
 * @notice Registers and triggers agents
 */
contract AutomationController {
    AgentExecutor public executor;
    mapping(address => bool) public agents;

    constructor() {}

    function setExecutor(address _executor) external {
        require(address(executor) == address(0), "Executor already set");
        executor = AgentExecutor(_executor);
    }

    function registerAgent(address agent) external {
        agents[agent] = true;
    }

    function executeAgent(address agent, bytes calldata data) external {
        require(agents[agent], "Agent not registered");
        executor.execute(agent, data);
    }
}
