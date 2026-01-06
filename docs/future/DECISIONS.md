1. Purpose of This Document

This document records explicit architectural decisions made during Phase 0 of the AgentFi protocol.

Its goals are to:

   1. Prevent architectural drift
   2. Capture rationale behind design choices
   3. Make assumptions explicit and reviewable
   4. Provide context for future contributors and auditors

All decisions recorded here are considered binding unless superseded by a future, explicit decision.

2. Identity as an NFT
   
Decision
   - Each autonomous agent is represented by an ERC-721 NFT.

Rationale
   - NFTs provide a clear, transferable ownership model
   - NFT ownership cleanly maps to ultimate control authority
   - Existing tooling and standards reduce custom complexity

Alternatives Considered
   - Non-transferable identities
   - Address-bound agents

These were rejected because they complicate ownership transfer and composability.

3. Execution via Token-Bound Accounts (ERC-6551)

Decision
   - All agent execution occurs through an ERC-6551 Token-Bound Account (TBA).

Rationale
   - Separates identity from execution
   - Avoids private key custody
   - Enables deterministic wallet derivation
   - Improves auditability of agent actions

Alternatives Considered
   - Embedded execution inside the NFT contract
   - Externally owned accounts (EOAs)

These were rejected due to custody risks and reduced transparency.

4. Delegated Execution with Revocable Authority

Decision
   - Off-chain agents operate as delegated signers, not owners.

Rationale
   - Enables autonomy without custody
   - Preserves owner sovereignty
   - Allows immediate revocation
   - Limits blast radius of compromised agents

Delegation is a capability, not a right.

5. Owner Sovereignty as a Non-Negotiable Invariant

Decision
   - The NFT owner is the ultimate authority at all times.

Rationale
   - Prevents permanent loss of control
   - Aligns with user expectations
   - Simplifies recovery and emergency handling
  
No mechanism may permanently override the owner.

6. On-Chain Correctness Over Off-Chain Trust
   
Decision
   - All critical validation occurs on-chain.

Rationale
   - Off-chain systems are inherently untrusted
   - On-chain enforcement is auditable
   - Reduces reliance on subjective guarantees

Off-chain intelligence may propose actions, but never enforce them.

7. Explicit Non-Goals in Phase 0

Decision
Phase 0 explicitly excludes:
   - Strategy optimization
   - Gas efficiency tuning
   - Profitability guarantees
   - UI/UX considerations
   - Fully trustless autonomy

Rationale
   - Early optimization increases risk and obscures correctness.

8. Phased Development Commitment
   
Decision
The protocol is developed in strict phases:
   - Architecture and threat modeling
   - Minimal viable contracts
   - Controlled extensions
   - Optional optimizations

Rationale
This enforces discipline and reduces systemic risk.

9. Decision Change Process

Decision
Any change to these decisions must:
   - Be explicitly documented
   - Include rationale
   - Reference the superseded decision
 
Silent changes are not permitted.