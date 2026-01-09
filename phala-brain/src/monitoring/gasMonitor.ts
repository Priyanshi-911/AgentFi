export async function shouldDelayTrade(gwei: number): Promise<boolean> {
  return gwei > 30;
}
