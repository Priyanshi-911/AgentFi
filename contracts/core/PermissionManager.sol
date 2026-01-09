// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ValidationLib } from "../libs/ValidationLib.sol";

/**
 * @title PermissionManager
 * @notice Manages which agents are allowed to execute which actions
 * @dev Pure permission registry, no execution logic
 */
contract PermissionManager {
    using ValidationLib for address;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event PermissionGranted(address indexed agent, address indexed action);
    event PermissionRevoked(address indexed agent, address indexed action);

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    // agent => action => allowed
    mapping(address => mapping(address => bool)) private _permissions;

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function isAllowed(address agent, address action) external view returns (bool) {
        return _permissions[agent][action];
    }

    /*//////////////////////////////////////////////////////////////
                        PERMISSION MANAGEMENT
    //////////////////////////////////////////////////////////////*/

    function grantPermission(address agent, address action) external {
        agent.ensureNonZero();
        action.ensureNonZero();

        _permissions[agent][action] = true;
        emit PermissionGranted(agent, action);
    }

    function revokePermission(address agent, address action) external {
        agent.ensureNonZero();
        action.ensureNonZero();

        _permissions[agent][action] = false;
        emit PermissionRevoked(agent, action);
    }
}
