// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { LifecycleManager } from "./LifecycleManager.sol";
import { ActionRouter } from "./ActionRouter.sol";
import { ExecutionTypes } from "../libs/ExecutionTypes.sol";
import { ValidationLib } from "../libs/ValidationLib.sol";

/**
 * @title AgentExecutor
 * @notice Central execution entrypoint for agents
 * @dev Enforces execution flow but delegates permissions and logic
 */
contract AgentExecutor {
    using ValidationLib for address;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event ExecutionPerformed(
        address indexed agent,
        address indexed action,
        bytes data,
        bytes result
    );

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    ActionRouter public immutable actionRouter;
    LifecycleManager public immutable lifecycleManager;


    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address actionRouter_, address lifecycleManager_) {
    actionRouter_.ensureNonZero();
    lifecycleManager_.ensureNonZero();

    actionRouter = ActionRouter(actionRouter_);
    lifecycleManager = LifecycleManager(lifecycleManager_);
}


    /*//////////////////////////////////////////////////////////////
                          EXECUTION LOGIC
    //////////////////////////////////////////////////////////////*/

    function execute(
    ExecutionTypes.ExecutionRequest calldata request
) external returns (bytes memory result) {
    // Basic validation
    request.agent.ensureNonZero();
    request.action.ensureNonZero();

    // 🔒 Lifecycle enforcement (ADD THIS HERE)
    if (!lifecycleManager.isActive(request.agent)) {
        revert LifecycleManager.AgentNotActive(request.agent);
    }

    // Route execution
    result = actionRouter.execute(
        request.agent,
        request.action,
        request.data
    );

    // Emit execution event
    emit ExecutionPerformed(
        request.agent,
        request.action,
        request.data,
        result
    );
}

    }


