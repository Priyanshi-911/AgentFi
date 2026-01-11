const hre = require("hardhat");

async function main() {
  const { ethers } = hre;

  // 🔁 Replace with your deployed addresses
  const CONTROLLER_ADDRESS = "0xa790C7a49ACB972cd7e12d2a3940E711D6CbE5f1";
  const AGENT_ADDRESS = "0xA6830DF0B6c68A567Da1dD6a452047EecdEA7497";

  const AutomationController = await ethers.getContractAt(
    "contracts/phase4/AutomationController.sol:AutomationController",
    CONTROLLER_ADDRESS
  );

  console.log("Executing agent...");

  const tx = await AutomationController.executeAgent(
    AGENT_ADDRESS,
    "0x" // empty payload
  );

  await tx.wait();

  console.log("✅ Agent execution successful");
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error("EXECUTION ERROR:");
    console.error(err);
    process.exit(1);
  });
