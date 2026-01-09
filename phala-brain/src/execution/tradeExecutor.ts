import { AgentInfo } from "../types/agent";

export async function executeTrade(
  agent: AgentInfo,
  calldata?: string
) {
  console.log("Executing trade for", agent.tba);
}
