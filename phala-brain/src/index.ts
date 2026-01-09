import { ethers } from "ethers";

import { Personality } from "./types/agent";
import type { AgentInfo, DecisionContext } from "./types/agent";

import { fetchAgents } from "./agents/agentManager";

import { degenStrategy } from "./strategies/degen";
import { stableStrategy } from "./strategies/stable";
import { balancedStrategy } from "./strategies/balanced";

import { buildDecisionTree } from "./decision/decisionTree";
import { storeDecision } from "./storage/ipfs";

import { executeTrade } from "./execution/tradeExecutor";
import { deployIdleCapital } from "./execution/yieldExecutor";

import { fetchSentiment } from "./sentiment/sentimentEngine";
import { shouldDelayTrade } from "./monitoring/gasMonitor";




/* =========================
   Configuration
   ========================= */

const RPC_URL = process.env.RPC_URL || "https://sepolia.infura.io/v3/YOUR_KEY";
const REGISTRY_ADDRESS = process.env.REGISTRY_ADDRESS || "0xRegistry";

/* =========================
   Providers & Contracts
   ========================= */

const provider = new ethers.JsonRpcProvider(RPC_URL);

// ABI is intentionally minimal (only what Brain needs)
const REGISTRY_ABI = [
  "function agentCount() view returns (uint256)",
  "function agents(uint256) view returns (address tba, address owner, uint8 personality)"
];

const registry = new ethers.Contract(
  REGISTRY_ADDRESS,
  REGISTRY_ABI,
  provider
);

/* =========================
   Context Builder
   ========================= */

async function buildContext(agent: AgentInfo): Promise<DecisionContext> {
  // Placeholder signals (replace with real feeds incrementally)
  const price = Math.random() * 2000;
  const rsi = Math.random() * 100;

  const gasGwei = Math.floor(Math.random() * 60);

  const sentiment = await fetchSentiment("ETH");

  return {
    agent,
    price,
    rsi,
    gas: {
      gwei: gasGwei,
      fast: gasGwei < 30
    },
    sentiment
  };
}

/* =========================
   Strategy Router
   ========================= */

function runStrategy(ctx: DecisionContext) {
  switch (ctx.agent.personality) {
    case Personality.DEGEN:
      return degenStrategy(ctx);
    case Personality.STABLE:
      return stableStrategy(ctx);
    case Personality.BALANCED:
    default:
      return balancedStrategy(ctx);
  }
}

/* =========================
   Main Brain Loop
   ========================= */

async function runBrain() {
  console.log("AgentFi Brain tick:", new Date().toISOString());

  const agents = await fetchAgents(registry);

  for (const agent of agents) {
    try {
      const context = await buildContext(agent);

      // Gas-aware execution
      if (await shouldDelayTrade(context.gas.gwei)) {
        console.log(`Gas too high for ${agent.tba}, skipping`);
        continue;
      }

      const result = runStrategy(context);

      const decisionTree = buildDecisionTree(result);
      const cid = await storeDecision(decisionTree);

      console.log(`Decision logged for ${agent.tba}: IPFS ${cid}`);

      if (result.decision === "BUY" || result.decision === "SELL") {
        await executeTrade(agent, context.calldata);
      } else {
        await deployIdleCapital(agent);
      }
    } catch (err) {
      console.error(`Agent ${agent.tba} failed`, err);
    }
  }
}

/* =========================
   Scheduler
   ========================= */

setInterval(runBrain, 60_000);

// Run immediately on boot
runBrain();
