// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AgentExecutor
 * @notice Executes an agent's logic
 */
contract AgentExecutor {
    address public controller;

    constructor(address _controller) {
        require(_controller != address(0), "Invalid controller");
        controller = _controller;
    }

    modifier onlyController() {
        require(msg.sender == controller, "Not controller");
        _;
    }

    function execute(address agent, bytes calldata data)
        external
        onlyController
        returns (bool)
    {
        (bool ok, ) = agent.call(
            abi.encodeWithSignature("execute(bytes)", data)
        );
        require(ok, "Execution failed");
        return true;
    }
}
