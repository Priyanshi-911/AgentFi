1. Overview and Scope

This document specifies the on-chain architecture for AgentFi, an autonomous NFT-based agent system.

The purpose of this document is to define:

    1. How an NFT represents an autonomous agent
    2. How that agent controls on-chain assets
    3. How execution authority is safely delegated
    4. What security and non-custodial guarantees are enforced

This document is intentionally limited to on-chain concerns. It does not define:

    - Off-chain agent logic
    - Frontend or user experience
    - Strategy or decision-making algorithms

Those are covered in separate documents.

2. Core On-Chain Abstractions

AgentFi is built around three primary on-chain abstractions:

    1. Agent NFT
    2. Token-Bound Account (TBA)
    3. Authorized Signers

Each abstraction has a single, well-defined responsibility.

2.1 Agent NFT (Identity Layer)

Each AgentFi agent is represented by a unique ERC-721 NFT.

The Agent NFT serves as:

    - The canonical identity of the agent
    - The ownership anchor for all agent-controlled assets
    - The root of authority for execution permissions

Key properties:

    - Ownership of the NFT implies ultimate control over the agent
    - Transferring the NFT transfers control of the agent
    - The NFT itself does not execute transactions

The NFT is intentionally passive. All execution occurs elsewhere.

2.2 Token-Bound Account (Execution Layer)

Each Agent NFT is associated with a Token-Bound Account (TBA) compliant with ERC-6551.

The TBA:

    - Is a smart contract wallet
    - Is deterministically derived from the NFT (contract + tokenId)
    - Holds all on-chain assets owned by the agent
    - Is the only contract that executes transactions on behalf of the agent

The TBA is considered the agent’s body, while the NFT is the agent’s identity.

Important invariants:

    - The TBA cannot exist without the NFT
    - The TBA has no private key

All execution is rule-based and auditable

2.3 Authorized Signers (Control Layer)

The TBA enforces a strict signer model.

There are exactly two categories of authorized signers:

    1. Primary Owner Signer
    2. Delegated Agent Signer

Each has different permissions and constraints.

3. Signer Model and Authority
3.1 Primary Owner Signer

The primary owner signer is the current owner of the Agent NFT.

Capabilities:

    1. Full administrative control
    2. Ability to transfer assets
    3. Ability to revoke or rotate delegated signers
    4. Ability to upgrade agent configuration (where permitted)
The owner signer is the ultimate authority.

No on-chain action can permanently override the owner.

3.2 Delegated Agent Signer (TEE)

The delegated agent signer represents an off-chain agent operating inside a Trusted Execution Environment (TEE).

Characteristics:

   1. Authorized by the TBA
   2. Permissioned, not sovereign
   3. Revocable at any time by the owner

Constraints:

   1. Cannot transfer ownership of the NFT
   2. Cannot self-authorize additional signers
   3. Cannot bypass TBA validation logic
This signer exists to enable autonomy without custody.

4. Transaction Authorization Flow

All transactions executed by the agent follow the same high-level flow:

   1. A transaction intent is constructed (off-chain)
   2. The delegated signer submits the transaction to the TBA
   3. The TBA validates:
         Signer authorization
         Transaction constraints
         Current agent state
   4. If valid, the transaction is executed
   5. Execution results are recorded on-chain

No transaction bypasses the TBA.

5. Non-Custodial and Security Guarantees

The architecture enforces the following guarantees:

   - Non-custodial: No off-chain system controls assets unilaterally
   - Revocability: All delegation is reversible by the NFT owner
   - Auditability: All actions are on-chain and inspectable
   - Transferability: Selling the NFT transfers agent control cleanly

These guarantees are architectural, not policy-based.

6. Explicit Non-Goals

This architecture explicitly does not attempt to:

   - Make the agent trustless without ownership
   - Hide execution logic
   - Prevent owner intervention
   - Optimize for gas efficiency prematurely

Correctness and safety take priority.

7. Future Extensions (Non-Binding)

Future versions may introduce:

   - Granular permission scopes
   - Strategy-specific execution limits
   - Multi-agent coordination primitives

These are intentionally excluded from Phase 1.