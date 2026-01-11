// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract BaseAgent {
    address public executor;

    constructor(address _executor) {
        require(_executor != address(0), "Invalid executor");
        executor = _executor;
    }

    modifier onlyExecutor() {
        require(msg.sender == executor, "Not executor");
        _;
    }

    // ❌ NO modifier here
    function execute(bytes calldata data)
        external
        virtual
        returns (bool);
}
