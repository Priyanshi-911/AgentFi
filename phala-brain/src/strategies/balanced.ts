import { DecisionContext, StrategyResult } from "../types/agent";

export function balancedStrategy(ctx: DecisionContext): StrategyResult {
  return {
    decision: "HOLD",
    confidence: 0.7,
    nodes: [
      { id: "RSI", value: ctx.rsi },
      { id: "Sentiment", value: ctx.sentiment.score }
    ]
  };
}
