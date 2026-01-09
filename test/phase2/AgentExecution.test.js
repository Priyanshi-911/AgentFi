import { expect } from "chai";
import hre from "hardhat";

const { ethers } = hre;

describe("Phase 2 – Agent Execution Flow", function () {
  let permissionManager;
  let lifecycleManager;
  let actionRouter;
  let agentExecutor;
  let testAction;
  let agent;

  beforeEach(async function () {
    const [_, agentSigner] = await ethers.getSigners();
    agent = agentSigner.address;

    const PermissionManager = await ethers.getContractFactory("PermissionManager");
    permissionManager = await PermissionManager.deploy();
    await permissionManager.waitForDeployment();

    const LifecycleManager = await ethers.getContractFactory("LifecycleManager");
    lifecycleManager = await LifecycleManager.deploy();
    await lifecycleManager.waitForDeployment();

    const ActionRouter = await ethers.getContractFactory("ActionRouter");
    actionRouter = await ActionRouter.deploy(permissionManager.target);
    await actionRouter.waitForDeployment();

    const AgentExecutor = await ethers.getContractFactory("AgentExecutor");
    agentExecutor = await AgentExecutor.deploy(
      actionRouter.target,
      lifecycleManager.target
    );
    await agentExecutor.waitForDeployment();

    const TestAction = await ethers.getContractFactory("TestAction");
    testAction = await TestAction.deploy();
    await testAction.waitForDeployment();
  });

  it("allows execution when agent is active and permitted", async function () {
    await lifecycleManager.activate(agent);
    await permissionManager.grantPermission(agent, testAction.target);

    await expect(
      agentExecutor.execute({
        agent,
        action: testAction.target,
        data: ethers.encodeBytes32String("hello"),
      })
    ).to.emit(agentExecutor, "ExecutionPerformed");
  });

  it("reverts when agent is not active", async function () {
    await expect(
      agentExecutor.execute({
        agent,
        action: testAction.target,
        data: "0x",
      })
    ).to.be.reverted;
  });
});
