// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LifecycleManager
 * @notice Manages lifecycle state of agents
 */
contract LifecycleManager {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error InvalidState();
    error AgentNotActive(address agent);

    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/

    enum AgentState {
        Inactive,
        Active,
        Paused,
        Retired
    }

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => AgentState) private _states;

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function stateOf(address agent) external view returns (AgentState) {
        return _states[agent];
    }

    function isActive(address agent) external view returns (bool) {
        return _states[agent] == AgentState.Active;
    }

    /*//////////////////////////////////////////////////////////////
                        STATE TRANSITIONS
    //////////////////////////////////////////////////////////////*/

    function activate(address agent) external {
        _states[agent] = AgentState.Active;
    }

    function pause(address agent) external {
        if (_states[agent] != AgentState.Active) revert InvalidState();
        _states[agent] = AgentState.Paused;
    }

    function retire(address agent) external {
        if (_states[agent] == AgentState.Retired) revert InvalidState();
        _states[agent] = AgentState.Retired;
    }
}
