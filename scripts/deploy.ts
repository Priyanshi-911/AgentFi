import { ethers } from "hardhat";

async function main() {
  console.log("Deploying AgentFi contracts...");

  const AgentRegistry = await ethers.getContractFactory("AgentRegistry");
  const registry = await AgentRegistry.deploy();
  await registry.waitForDeployment();

  const AgentExecutor = await ethers.getContractFactory("AgentExecutor");
  const executor = await AgentExecutor.deploy(await registry.getAddress());
  await executor.waitForDeployment();

  const AutomationController = await ethers.getContractFactory("AutomationController");
  const controller = await AutomationController.deploy(
    await registry.getAddress(),
    await executor.getAddress()
  );
  await controller.waitForDeployment();

  console.log("AgentRegistry:", await registry.getAddress());
  console.log("AgentExecutor:", await executor.getAddress());
  console.log("AutomationController:", await controller.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
