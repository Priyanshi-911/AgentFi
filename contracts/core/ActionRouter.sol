// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IAction } from "../actions/IAction.sol";
import { PermissionManager } from "./PermissionManager.sol";
import { ValidationLib } from "../libs/ValidationLib.sol";

/**
 * @title ActionRouter
 * @notice Routes execution requests to actions after permission checks
 * @dev Stateless execution dispatcher
 */
contract ActionRouter {
    using ValidationLib for address;

    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error PermissionDenied(address agent, address action);

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    PermissionManager public immutable permissionManager;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address permissionManager_) {
        permissionManager_.ensureNonZero();
        permissionManager = PermissionManager(permissionManager_);
    }

    /*//////////////////////////////////////////////////////////////
                          EXECUTION LOGIC
    //////////////////////////////////////////////////////////////*/

    function execute(
        address agent,
        address action,
        bytes calldata data
    ) external returns (bytes memory result) {
        agent.ensureNonZero();
        action.ensureNonZero();

        if (!permissionManager.isAllowed(agent, action)) {
            revert PermissionDenied(agent, action);
        }

        result = IAction(action).execute(data);
    }
}
