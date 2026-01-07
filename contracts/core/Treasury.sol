// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Errors } from "../libraries/Errors.sol";
import { Policy } from "./Policy.sol";

/**
 * @title Treasury
 * @author AgentiFi
 * @notice Minimal custody contract for protocol funds
 * @dev Phase 1: ETH custody with policy-gated withdrawals
 */
contract Treasury {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount, uint256 indexed agentId);
    event PolicyUpdated(address indexed oldPolicy, address indexed newPolicy);

    /*//////////////////////////////////////////////////////////////
                               STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Policy contract used for authorization
    Policy public policy;

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

    constructor(address initialGovernance, address initialPolicy) {
        if (initialGovernance == address(0)) revert Errors.InvalidOwner();
        if (initialPolicy == address(0)) revert Errors.InvalidImplementation();
        governance = initialGovernance;
        policy = Policy(initialPolicy);
    }

    /*//////////////////////////////////////////////////////////////
                       GOVERNANCE CONFIGURATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Update the Policy reference
    function setPolicy(address newPolicy) external onlyGovernance {
        if (newPolicy == address(0)) revert Errors.InvalidImplementation();
        address old = address(policy);
        policy = Policy(newPolicy);
        emit PolicyUpdated(old, newPolicy);
    }

    /*//////////////////////////////////////////////////////////////
                             DEPOSITS
    //////////////////////////////////////////////////////////////*/

    /// @notice Accept ETH deposits
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    /*//////////////////////////////////////////////////////////////
                            WITHDRAWALS
    //////////////////////////////////////////////////////////////*/

    /// @notice Withdraw ETH to a recipient, authorized by Policy
    function withdraw(uint256 agentId, address to, uint256 amount) external {
        if (to == address(0)) revert Errors.InvalidOwner();
        if (amount == 0) revert Errors.InvalidAmount();
        if (address(this).balance < amount) revert Errors.InsufficientBalance();

        // enforce authorization via Policy
        policy.requireCanExecute(agentId, msg.sender);

        (bool ok, ) = to.call{value: amount}("");
        if (!ok) revert Errors.InvalidAmount();

        emit Withdrawn(to, amount, agentId);
    }
}
