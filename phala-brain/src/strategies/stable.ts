import { DecisionContext, StrategyResult } from "../types/agent";

export function stableStrategy(ctx: DecisionContext): StrategyResult {
  return {
    decision: "YIELD",
    confidence: 0.6,
    nodes: [{ id: "GasFast", value: ctx.gas.fast }]
  };
}
