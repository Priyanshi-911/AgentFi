// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Errors } from "../libraries/Errors.sol";

/**
 * @title AgentCore
 * @author AgentiFi
 * @notice Core on-chain agent lifecycle management
 * @dev Phase 1: identity, ownership, executors, activation state
 */
contract AgentCore {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event AgentCreated(uint256 indexed agentId, address indexed owner, address indexed executor);
    event ExecutorUpdated(uint256 indexed agentId, address indexed oldExecutor, address indexed newExecutor);
    event AgentStatusUpdated(uint256 indexed agentId, bool active);

    /*//////////////////////////////////////////////////////////////
                               STORAGE
    //////////////////////////////////////////////////////////////*/

    struct Agent {
        address owner;
        address executor;
        bool active;
    }

    uint256 private nextAgentId = 1;
    mapping(uint256 => Agent) private agents;

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyAgentOwner(uint256 agentId) {
        if (agents[agentId].owner == address(0)) revert Errors.InvalidAgent();
        if (msg.sender != agents[agentId].owner) revert Errors.NotAgentOwner();
        _;
    }

    modifier onlyExecutor(uint256 agentId) {
        if (agents[agentId].owner == address(0)) revert Errors.InvalidAgent();
        if (!agents[agentId].active) revert Errors.AgentInactive();
        if (msg.sender != agents[agentId].executor) revert Errors.NotExecutor();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                         AGENT CREATION
    //////////////////////////////////////////////////////////////*/

    function createAgent(address owner, address executor) external returns (uint256 agentId) {
        if (owner == address(0)) revert Errors.InvalidOwner();
        if (executor == address(0)) revert Errors.InvalidExecutor();

        agentId = nextAgentId++;
        agents[agentId] = Agent({
            owner: owner,
            executor: executor,
            active: true
        });

        emit AgentCreated(agentId, owner, executor);
    }

    /*//////////////////////////////////////////////////////////////
                      AGENT CONFIGURATION
    //////////////////////////////////////////////////////////////*/

    function setExecutor(uint256 agentId, address newExecutor) external onlyAgentOwner(agentId) {
        if (newExecutor == address(0)) revert Errors.InvalidExecutor();
        address old = agents[agentId].executor;
        agents[agentId].executor = newExecutor;
        emit ExecutorUpdated(agentId, old, newExecutor);
    }

    function setActive(uint256 agentId, bool active) external onlyAgentOwner(agentId) {
        agents[agentId].active = active;
        emit AgentStatusUpdated(agentId, active);
    }

    /*//////////////////////////////////////////////////////////////
                         AGENT READS
    //////////////////////////////////////////////////////////////*/

    function getAgent(uint256 agentId)
        external
        view
        returns (address owner, address executor, bool active)
    {
        Agent memory a = agents[agentId];
        if (a.owner == address(0)) revert Errors.InvalidAgent();
        return (a.owner, a.executor, a.active);
    }

    function canExecute(uint256 agentId, address caller) external view returns (bool) {
        Agent memory a = agents[agentId];
        if (a.owner == address(0)) return false;
        if (!a.active) return false;
        return caller == a.executor;
    }
}
