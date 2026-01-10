// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice Interface for AgentExecutor (Phase 3)
 * Using an interface avoids import and symbol resolution issues
 */
interface IAgentExecutor {
    function execute(
        address user,
        address agent,
        address target,
        bytes calldata data
    ) external;
}

contract AutomationController {
    IAgentExecutor public executor;

    struct Automation {
        address user;
        address agent;
        address target;
        bytes data;
        uint256 executeAfter;
        bool executed;
    }

    uint256 public automationCount;
    mapping(uint256 => Automation) public automations;

    event AutomationScheduled(uint256 indexed id, address indexed user);
    event AutomationExecuted(uint256 indexed id);

    constructor(address _executor) {
        executor = IAgentExecutor(_executor);
    }

    /**
     * @notice Schedule an automation for future execution
     */
    function scheduleAutomation(
        address agent,
        address target,
        bytes calldata data,
        uint256 executeAfter
    ) external returns (uint256) {
        require(executeAfter > block.timestamp, "Invalid execution time");

        automationCount++;

        automations[automationCount] = Automation({
            user: msg.sender,
            agent: agent,
            target: target,
            data: data,
            executeAfter: executeAfter,
            executed: false
        });

        emit AutomationScheduled(automationCount, msg.sender);
        return automationCount;
    }

    /**
     * @notice Execute a scheduled automation once the time has passed
     */
    function executeAutomation(uint256 id) external {
        Automation storage a = automations[id];

        require(!a.executed, "Already executed");
        require(block.timestamp >= a.executeAfter, "Too early");

        a.executed = true;

        executor.execute(
            a.user,
            a.agent,
            a.target,
            a.data
        );

        emit AutomationExecuted(id);
    }
}
