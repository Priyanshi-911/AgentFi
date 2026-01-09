import { StrategyResult, DecisionTree } from "../types/agent";
import { v4 as uuid } from "uuid";

export function buildDecisionTree(result: StrategyResult): DecisionTree {
  return {
    id: uuid(),
    timestamp: Date.now(),
    root: "Start",
    nodes: result.nodes,
    decision: result.decision,
    confidence: result.confidence
  };
}
