const hre = require("hardhat");

async function main() {
  const { ethers } = hre;

  const EXECUTOR_ADDRESS =
    "0x5b85e1ea43e44f2f737fd23fb164943cd1d02ccd";

  const SimpleActionAgent = await ethers.getContractFactory(
    "contracts/agents/SimpleActionAgent.sol:SimpleActionAgent"
  );

  const agent = await SimpleActionAgent.deploy(EXECUTOR_ADDRESS);

  const receipt = await agent.deploymentTransaction().wait();

  const agentAddress = await agent.getAddress();

  console.log("DEPLOYED AGENT ADDRESS:", agentAddress);
  console.log("TX HASH:", receipt.hash);
}

main().then(() => process.exit(0)).catch(console.error);
