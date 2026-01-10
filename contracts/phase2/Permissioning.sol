// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Permissioning {
    mapping(address => mapping(address => bool)) private _approvedAgents;

    event AgentApproved(address indexed user, address indexed agent);
    event AgentRevoked(address indexed user, address indexed agent);

    function approveAgent(address agent) external {
        _approvedAgents[msg.sender][agent] = true;
        emit AgentApproved(msg.sender, agent);
    }

    function revokeAgent(address agent) external {
        _approvedAgents[msg.sender][agent] = false;
        emit AgentRevoked(msg.sender, agent);
    }

    function isAgentApproved(address user, address agent)
        external
        view
        returns (bool)
    {
        return _approvedAgents[user][agent];
    }
}
