const hre = require("hardhat");

async function main() {
  const { ethers } = hre;

  // 1. Deploy AutomationController FIRST
  const AutomationController = await ethers.getContractFactory(
    "contracts/phase4/AutomationController.sol:AutomationController"
  );
  const controller = await AutomationController.deploy();
  await controller.waitForDeployment();
  const controllerAddress = await controller.getAddress();
  console.log("AutomationController:", controllerAddress);

  // 2. Deploy AgentExecutor(controller)
  const AgentExecutor = await ethers.getContractFactory(
    "contracts/core/AgentExecutor.sol:AgentExecutor"
  );
  const executor = await AgentExecutor.deploy(controllerAddress);
  await executor.waitForDeployment();
  const executorAddress = await executor.getAddress();
  console.log("AgentExecutor:", executorAddress);

  // 3. Wire executor into controller
  await (await controller.setExecutor(executorAddress)).wait();
  console.log("Executor wired");

  // 4. Deploy SimpleActionAgent(executor)
  const SimpleActionAgent = await ethers.getContractFactory("SimpleActionAgent");
  const agent = await SimpleActionAgent.deploy(executorAddress);
  await agent.waitForDeployment();
  const agentAddress = await agent.getAddress();
  console.log("SimpleActionAgent:", agentAddress);

  // 5. Register agent
  await (await controller.registerAgent(agentAddress)).wait();
  console.log("Agent registered");
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error("DEPLOY ERROR:");
    console.error(err);
    process.exit(1);
  });
