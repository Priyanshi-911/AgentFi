// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address actionRouter_) {
        actionRouter_.ensureNonZero();
        actionRouter = ActionRouter(actionRouter_);
    }

    /*//////////////////////////////////////////////////////////////
                          EXECUTION LOGIC
    //////////////////////////////////////////////////////////////*/

    function execute(
        ExecutionTypes.ExecutionRequest calldata request
    ) external returns (bytes memory result) {
        request.agent.ensureNonZero();
        request.action.ensureNonZero();

        result = actionRouter.execute(
            request.agent,
            request.action,
            request.data
        );

        emit ExecutionPerformed(
            request.agent,
            request.action,
            request.data,
            result
        );
    }
}

