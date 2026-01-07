// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Errors } from "../libraries/Errors.sol";

/**
 * @title Registry
 * @author AgentiFi
 * @notice Global on-chain registry for protocol components
 * @dev Phase 1: minimal, deterministic, governance-gated
 */
contract Registry {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Registered(bytes32 indexed key, address indexed implementation);
    event StatusUpdated(bytes32 indexed key, bool enabled);
    event GovernanceTransferred(address indexed oldGov, address indexed newGov);

    /*//////////////////////////////////////////////////////////////
                               STORAGE
    //////////////////////////////////////////////////////////////*/

    struct Entry {
        address implementation;
        bool enabled;
    }

    /// @notice governance address with mutation authority
    address public governance;

    /// @notice mapping of system keys to registry entries
    mapping(bytes32 => Entry) private entries;

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

    constructor(address initialGovernance) {
        if (initialGovernance == address(0)) revert Errors.InvalidOwner();
        governance = initialGovernance;
        emit GovernanceTransferred(address(0), initialGovernance);
    }

    /*//////////////////////////////////////////////////////////////
                        GOVERNANCE MANAGEMENT
    //////////////////////////////////////////////////////////////*/

    function transferGovernance(address newGovernance) external onlyGovernance {
        if (newGovernance == address(0)) revert Errors.InvalidOwner();
        address old = governance;
        governance = newGovernance;
        emit GovernanceTransferred(old, newGovernance);
    }

    /*//////////////////////////////////////////////////////////////
                         REGISTRY MUTATIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Register a new system component
    function register(bytes32 key, address implementation) external onlyGovernance {
        if (key == bytes32(0)) revert Errors.RegistryNotFound();
        if (implementation == address(0)) revert Errors.InvalidImplementation();
        if (entries[key].implementation != address(0)) revert Errors.RegistryAlreadyExists();

        entries[key] = Entry({ implementation: implementation, enabled: true });
        emit Registered(key, implementation);
    }

    /// @notice Enable or disable a registered component
    function setStatus(bytes32 key, bool enabled) external onlyGovernance {
        if (entries[key].implementation == address(0)) revert Errors.RegistryNotFound();
        entries[key].enabled = enabled;
        emit StatusUpdated(key, enabled);
    }

    /*//////////////////////////////////////////////////////////////
                           REGISTRY READS
    //////////////////////////////////////////////////////////////*/

    /// @notice Resolve a component address; reverts if missing or disabled
    function resolve(bytes32 key) external view returns (address impl) {
        Entry memory e = entries[key];
        if (e.implementation == address(0)) revert Errors.RegistryNotFound();
        if (!e.enabled) revert Errors.RegistryDisabled();
        return e.implementation;
    }

    /// @notice Check whether a key exists
    function exists(bytes32 key) external view returns (bool) {
        return entries[key].implementation != address(0);
    }

    /// @notice Get raw entry data (for governance / tooling)
    function getEntry(bytes32 key) external view returns (address implementation, bool enabled) {
        Entry memory e = entries[key];
        if (e.implementation == address(0)) revert Errors.RegistryNotFound();
        return (e.implementation, e.enabled);
    }
}
