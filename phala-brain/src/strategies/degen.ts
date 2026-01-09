import { DecisionContext, StrategyResult } from "../types/agent";

export function degenStrategy(ctx: DecisionContext): StrategyResult {
  return {
    decision: "HOLD",
    confidence: 0.8,
    nodes: [{ id: "RSI", value: ctx.rsi }]
  };
}
