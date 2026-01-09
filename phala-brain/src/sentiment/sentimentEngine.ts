export async function fetchSentiment(_ticker: string) {
  return {
    score: 0.5,
    sources: { twitter: 0.5, reddit: 0.5 }
  };
}
