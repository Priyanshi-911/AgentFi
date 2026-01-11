const hre = require("hardhat");

async function main() {
  const { ethers } = hre;

const EXECUTOR_ADDRESS = "0x5b85e1ea43e44f2f737fd23fb164943cd1d02ccd";
  const CONTROLLER_ADDRESS = "0xa790C7a49ACB972cd7e12d2a3940E711D6CbE5f1";

  const SimpleActionAgent = await ethers.getContractFactory("SimpleActionAgent");
  const agent = await SimpleActionAgent.deploy(EXECUTOR_ADDRESS);
  await agent.waitForDeployment();

  const agentAddress = await agent.getAddress();
  console.log("New SimpleActionAgent:", agentAddress);

  const controller = await ethers.getContractAt(
    "contracts/phase4/AutomationController.sol:AutomationController",
    CONTROLLER_ADDRESS
  );

  await (await controller.registerAgent(agentAddress)).wait();
  console.log("New agent registered");
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
