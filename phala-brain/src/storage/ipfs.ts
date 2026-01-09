export async function storeDecision(tree: unknown): Promise<string> {
  console.log("Mock IPFS store", tree);
  return "QmMockCID";
}
