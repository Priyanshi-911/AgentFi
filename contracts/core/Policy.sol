// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Errors } from "../libraries/Errors.sol";
import { AgentCore } from "./AgentCore.sol";

/**
 * @title Policy
 * @author AgentiFi
 * @notice Central authorization oracle for protocol actions
 * @dev Phase 1: minimal, deterministic permission checks
 */
contract Policy {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event AgentCoreUpdated(address indexed oldAgentCore, address indexed newAgentCore);

    /*//////////////////////////////////////////////////////////////
                               STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice reference to AgentCore contract
    AgentCore public agentCore;

    /// @notice governance address
    address public governance;

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyGovernance() {
        if (msg.sender != governance) revert Errors.Unauthorized();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address initialGovernance, address initialAgentCore) {
        if (initialGovernance == address(0)) revert Errors.InvalidOwner();
        if (initialAgentCore == address(0)) revert Errors.InvalidImplementation();

        governance = initialGovernance;
        agentCore = AgentCore(initialAgentCore);
    }

    /*//////////////////////////////////////////////////////////////
                       GOVERNANCE CONFIGURATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Update AgentCore reference
    function setAgentCore(address newAgentCore) external onlyGovernance {
        if (newAgentCore == address(0)) revert Errors.InvalidImplementation();
        address old = address(agentCore);
        agentCore = AgentCore(newAgentCore);
        emit AgentCoreUpdated(old, newAgentCore);
    }

    /*//////////////////////////////////////////////////////////////
                        AUTHORIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Check whether a caller may execute on behalf of an agent
    function canExecute(uint256 agentId, address caller) external view returns (bool) {
        return agentCore.canExecute(agentId, caller);
    }

    /// @notice Enforce execution permission (reverts if not allowed)
    function requireCanExecute(uint256 agentId, address caller) external view {
        bool allowed = agentCore.canExecute(agentId, caller);
        if (!allowed) revert Errors.Unauthorized();
    }
}
