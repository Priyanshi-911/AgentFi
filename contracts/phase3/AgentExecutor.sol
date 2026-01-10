// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../phase2/Permissioning.sol";

/**
 * @title AgentExecutor
 * @notice Executes transactions on behalf of users via approved agents
 */
contract AgentExecutor {
    Permissioning public permissioning;

    event ActionExecuted(
        address indexed agent,
        address indexed user,
        address target,
        bytes data
    );

    constructor(address _permissioning) {
        permissioning = Permissioning(_permissioning);
    }

    /**
     * @notice Execute a transaction on behalf of a user
     * @param user The user who owns the permission
     * @param agent The approved agent acting for the user
     * @param target The contract to be called
     * @param data Encoded function call data
     */
    function execute(
        address user,
        address agent,
        address target,
        bytes calldata data
    ) external {
        require(
            permissioning.isAgentApproved(user, agent),
            "Agent not approved"
        );

        (bool success, ) = target.call(data);
        require(success, "Execution failed");

        emit ActionExecuted(agent, user, target, data);
    }
}
