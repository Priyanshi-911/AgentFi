const hre = require("hardhat");

async function main() {
  const permissioning = await hre.ethers.getContract("Permissioning");

  const AgentExecutor = await hre.ethers.getContractFactory("AgentExecutor");
  const executor = await AgentExecutor.deploy(permissioning.address);

  await executor.waitForDeployment();

  console.log("AgentExecutor deployed to:", await executor.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
