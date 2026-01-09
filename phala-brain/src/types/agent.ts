export enum Personality {
  DEGEN = 0,
  STABLE = 1,
  BALANCED = 2
}

export interface AgentInfo {
  tba: string;
  owner: string;
  personality: Personality;
}

export interface GasContext {
  gwei: number;
  fast: boolean;
}

export interface SentimentContext {
  score: number;
  sources: {
    twitter: number;
    reddit: number;
  };
}

export interface DecisionContext {
  agent: AgentInfo;
  price: number;
  rsi: number;
  gas: GasContext;
  sentiment: SentimentContext;
  calldata?: string;
}

export interface DecisionNode {
  id: string;
  value: string | number | boolean;
}

export interface StrategyResult {
  decision: "BUY" | "SELL" | "HOLD" | "YIELD";
  confidence: number;
  nodes: DecisionNode[];
}

export interface DecisionTree {
  id: string;
  timestamp: number;
  root: string;
  nodes: DecisionNode[];
  decision: string;
  confidence: number;
}
