// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC6551Account } from "erc6551/interfaces/IERC6551Account.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { Errors } from "../libraries/Errors.sol";

/**
 * @title AgentFiTBA
 * @notice ERC-6551 Token Bound Account with Brain-authorized execution
 */
contract AgentFiTBA is IERC6551Account {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event BrainAuthorized(address indexed brain);
    event BrainRevoked(address indexed brain);
    event BrainExecution(address indexed brain, address indexed target, bytes data);

    /*//////////////////////////////////////////////////////////////
                               STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => bool) public isAuthorizedBrain;

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() {
        if (msg.sender != owner()) revert Errors.Unauthorized();
        _;
    }

    modifier onlyBrain() {
        if (!isAuthorizedBrain[msg.sender]) revert Errors.Unauthorized();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        ERC-6551 REQUIRED FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns the NFT owner (NOT part of IERC6551Account)
    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);
        return IERC721(tokenContract).ownerOf(tokenId);
    }

    /// @notice ERC-6551 token binding
    function token()
        public
        view
        override
        returns (uint256 chainId, address tokenContract, uint256 tokenId)
    {
        assembly {
            chainId := shr(96, calldataload(0))
            tokenContract := shr(96, calldataload(32))
            tokenId := calldataload(64)
        }
    }

    /// @notice ERC-6551 state (static)
    function state() external pure override returns (uint256) {
        return 0;
    }

    /// @notice ERC-1271-compatible signer validation
    function isValidSigner(
        address signer,
        bytes calldata
    ) external view override returns (bytes4) {
        if (signer == owner()) {
            return 0x1626ba7e; // ERC1271_MAGICVALUE
        }
        return 0xffffffff;
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IERC6551Account).interfaceId;
    }

    /*//////////////////////////////////////////////////////////////
                        BRAIN AUTHORIZATION
    //////////////////////////////////////////////////////////////*/

    function authorizeBrain(address brain) external onlyOwner {
        if (brain == address(0)) revert Errors.InvalidImplementation();
        isAuthorizedBrain[brain] = true;
        emit BrainAuthorized(brain);
    }

    function revokeBrain(address brain) external onlyOwner {
        isAuthorizedBrain[brain] = false;
        emit BrainRevoked(brain);
    }

    /*//////////////////////////////////////////////////////////////
                        EXECUTION (BRAIN ONLY)
    //////////////////////////////////////////////////////////////*/

    function execute(
        address target,
        uint256 value,
        bytes calldata data
    ) external onlyBrain returns (bytes memory result) {
        if (target == address(0)) revert Errors.InvalidImplementation();

        (bool success, bytes memory res) =
            target.call{value: value}(data);

        if (!success) revert Errors.Unauthorized();

        emit BrainExecution(msg.sender, target, data);
        return res;
    }

    receive() external payable {}
    fallback() external payable {}
}
