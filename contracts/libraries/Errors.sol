// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Errors
 * @author AgentiFi
 * @notice Centralized error definitions for Phase 1 on-chain contracts
 * @dev All contracts MUST use these custom errors. Inline revert strings are forbidden.
 */
library Errors {
    /*//////////////////////////////////////////////////////////////
                                AUTH
    //////////////////////////////////////////////////////////////*/

    /// @notice Caller is not authorized to perform this action
    error Unauthorized();

    /// @notice Caller is not the agent owner
    error NotAgentOwner();

    /// @notice Caller is not the assigned executor
    error NotExecutor();

    /*//////////////////////////////////////////////////////////////
                              AGENT
    //////////////////////////////////////////////////////////////*/

    /// @notice Agent does not exist or is invalid
    error InvalidAgent();

    /// @notice Agent is inactive
    error AgentInactive();

    /// @notice Executor address is invalid
    error InvalidExecutor();

    /// @notice Owner address is invalid
    error InvalidOwner();

    /*//////////////////////////////////////////////////////////////
                             REGISTRY
    //////////////////////////////////////////////////////////////*/

    /// @notice Registry entry already exists
    error RegistryAlreadyExists();

    /// @notice Registry entry does not exist
    error RegistryNotFound();

    /// @notice Registry entry is disabled
    error RegistryDisabled();

    /// @notice Implementation address is invalid
    error InvalidImplementation();

    /*//////////////////////////////////////////////////////////////
                             TREASURY
    //////////////////////////////////////////////////////////////*/

    /// @notice Withdrawal amount is zero or exceeds balance
    error InvalidAmount();

    /// @notice Treasury has insufficient balance
    error InsufficientBalance();

    /*//////////////////////////////////////////////////////////////
                             GOVERNANCE
    //////////////////////////////////////////////////////////////*/

    /// @notice Upgrade or governance action is not allowed
    error GovernanceRestricted();

    /// @notice Timelock has not expired
    error TimelockActive();
}
