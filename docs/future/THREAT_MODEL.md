1. Purpose and Scope

This document defines the threat model for the AgentFi protocol.

Its purpose is to:

   1. Identify realistic adversaries
   2. Enumerate attack surfaces
   3. Analyze failure modes
   4. Document mitigations and accepted risks

This threat model applies only to:

   1. On-chain contracts
   2. Off-chain agents acting as delegated signers
   3. The interaction boundary between them

It does not cover:

   1. User interface vulnerabilities
   2. Social engineering attacks
   3. Off-chain infrastructure availability (unless it affects custody or execution safety)
   
2. Assets to Protect

The protocol explicitly aims to protect the following assets:

   1. On-chain funds held by Token-Bound Accounts
   2. Control authority over agent execution
   3. Ownership rights implied by Agent NFTs
   4. Integrity of transaction execution
Loss of any of the above constitutes a protocol failure.

3. Adversary Model
   
3.1 External Adversary

An external adversary:

   1. Has no legitimate authorization
   2. Can submit arbitrary transactions
   3. Can observe all on-chain state
   4. May attempt to exploit smart contract bugs

This adversary is assumed to be economically rational.

3.2 Malicious Delegated Agent

A malicious delegated agent:

   1. Possesses valid signer authorization
   2. Operates within a TEE but may attempt malicious behavior
   3. May attempt to exceed intended permissions
This adversary is realistic and explicitly considered.

3.3 Malicious or Negligent Owner

The NFT owner may:

   1. Misconfigure delegation
   2. Delegate authority carelessly
   3. Intentionally drain assets
This is considered out of scope for protocol protection.
The protocol does not protect users from themselves.

4. Attack Surfaces

The primary attack surfaces are:

   1. Token-Bound Account execution logic
   2. Signer authorization and validation
   3. Delegation and revocation mechanisms
   4. ERC-6551 binding assumptions
   5. Cross-contract interactions initiated by the agent

Each surface is analyzed independently.

5. Threat Analysis and Mitigations
   
5.1 Unauthorized Transaction Execution

Threat:

An attacker attempts to execute transactions from a TBA without authorization.

Mitigations:

   1. Strict signer validation inside the TBA
   2. No private keys held off-chain
   3. All execution paths gated by authorization checks

5.2 Delegated Signer Privilege Escalation

Threat:
A delegated signer attempts to exceed its permitted authority.

Mitigations:
   1. Explicit permission boundaries enforced on-chain
   2. No ability to self-authorize additional signers
   3. Owner-controlled revocation at all times
   
5.3 Compromised Off-Chain Agent

Threat:
The off-chain agent behaves maliciously or is compromised.

Mitigations:
   1. Limited on-chain authority
   2. Immediate revocation capability
   3. No custody of private keys or assets
   4. Residual risk is accepted.

5.4 Replay or Transaction Injection Attacks

Threat:
Previously valid transactions are replayed or malicious payloads are injected.

Mitigations:
   1. Nonce-based execution where applicable
   2. Context-aware validation inside the TBA
   3. Deterministic execution paths
   
6. Accepted Risks

The protocol explicitly accepts the following risks:

   1. Owner misconfiguration or negligence
   2. Economic losses due to poor strategy decisions
   3. Liveness failures of off-chain agents
These risks are inherent to autonomous systems and are not mitigated at the protocol level.

1. Non-Goals

The threat model does not attempt to:

   1. Eliminate all financial risk
   2. Prevent owner-authorized malicious actions
   3. Guarantee profitability or correctness of agent strategies
   4. Defend against off-chain infrastructure outages