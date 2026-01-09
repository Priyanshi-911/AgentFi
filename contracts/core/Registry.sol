// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Errors } from "../libraries/Errors.sol";

/*//////////////////////////////////////////////////////////////
                        AGENT ENUMS & STRUCTS
//////////////////////////////////////////////////////////////*/

enum Personality {
    DEGEN,
    STABLE,
    BALANCED
}

struct AgentInfo {
    address tba;
    address owner;
    Personality personality;
}

/**
 * @title Registry
 * @author AgentiFi
 * @notice Global on-chain registry for protocol components + Agent discovery
 * @dev Phase 1–2 compatible, additive refactor only
 */
contract Registry {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Registered(bytes32 indexed key, address indexed implementation);
    event StatusUpdated(bytes32 indexed key, bool enabled);
    event GovernanceTransferred(address indexed oldGov, address indexed newGov);

    /// @notice Emitted when a new Agent is registered (Brain indexing optional)
    event AgentRegistered(address indexed tba, address indexed owner, Personality personality);

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

    /// @notice ordered list of all Agents (Brain polling source of truth)
    AgentInfo[] private _agents;

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
                        AGENT REGISTRATION (NEW)
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Register a newly created AgentAccount for Brain discovery
     * @dev Intended to be called by Factory / NFT hook
     * @param tba ERC-6551 AgentAccount address
     * @param owner NFT owner
     * @param personality Selected agent personality
     */
    function registerAgent(
        address tba,
        address owner,
        Personality personality
    ) external onlyGovernance {
        if (tba == address(0)) revert Errors.InvalidImplementation();
        if (owner == address(0)) revert Errors.InvalidOwner();

        _agents.push(
            AgentInfo({
                tba: tba,
                owner: owner,
                personality: personality
            })
        );

        emit AgentRegistered(tba, owner, personality);
    }

    /*//////////////////////////////////////////////////////////////
                        AGENT DISCOVERY (BRAIN)
    //////////////////////////////////////////////////////////////*/

    /// @notice Total number of registered Agents
    function agentCount() external view returns (uint256) {
        return _agents.length;
    }

    /// @notice Fetch Agent data by index (Brain polling API)
    function agents(uint256 index)
        external
        view
        returns (
            address tba,
            address owner,
            uint8 personality
        )
    {
        AgentInfo storage a = _agents[index];
        return (a.tba, a.owner, uint8(a.personality));
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
