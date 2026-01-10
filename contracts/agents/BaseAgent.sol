// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BaseAgent
 * @notice Abstract base contract for all AgentiFi agents.
 */
abstract contract BaseAgent {
    /// @notice Authorized executor contract
    address public immutable executor;

    /// @dev Restricts calls to the AgentExecutor
    modifier onlyExecutor() {
        require(msg.sender == executor, "BaseAgent: caller is not executor");
        _;
    }

    /**
     * @param _executor Address of the AgentExecutor contract
     */
    constructor(address _executor) {
        require(_executor != address(0), "BaseAgent: invalid executor");
        executor = _executor;
    }

    /**
     * @notice Executes agent-specific logic
     * @param data Encoded execution payload
     * @return success Boolean execution status
     */
    function execute(bytes calldata data)
        external
        virtual
        returns (bool success);
}
