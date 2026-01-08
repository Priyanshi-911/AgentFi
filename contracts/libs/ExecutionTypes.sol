// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ExecutionTypes
 * @notice Shared execution data structures for Phase 2
 * @dev Contains only structs and enums, no logic
 */
library ExecutionTypes {
    /**
     * @notice Represents a single executable action request
     * @param agent The agent initiating the execution
     * @param action The action contract to be executed
     * @param data Encoded calldata for the action
     */
    struct ExecutionRequest {
        address agent;
        address action;
        bytes data;
    }

    /**
     * @notice Represents a batch of execution requests
     * @dev Intended for atomic multi-action execution
     */
    struct ExecutionBatch {
        ExecutionRequest[] requests;
    }

    /**
     * @notice Result of an execution
     * @param success Whether execution succeeded
     * @param result Raw returned data
     */
    struct ExecutionResult {
        bool success;
        bytes result;
    }
}
