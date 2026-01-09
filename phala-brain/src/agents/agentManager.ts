import { ethers } from "ethers";
import { AgentInfo, Personality } from "../types/agent";

/**
 * Fetch all registered Agent accounts from the on-chain Registry
 * The Brain ONLY trusts the Registry as source of truth
 */
export async function fetchAgents(
  registry: ethers.Contract
): Promise<AgentInfo[]> {
  const count: bigint = await registry.agentCount();
  const agents: AgentInfo[] = [];

  for (let i = 0; i < Number(count); i++) {
    const agent = await registry.agents(i);

    agents.push({
      tba: agent.tba,
      owner: agent.owner,
      personality: Number(agent.personality) as Personality
    });
  }

  return agents;
}
