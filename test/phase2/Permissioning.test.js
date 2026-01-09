import { expect } from "chai";
import hre from "hardhat";

const { ethers } = hre;

describe("Phase 2 – PermissionManager", function () {
  let permissionManager;
  let agent;
  let action;

  beforeEach(async function () {
    const [, agentSigner, actionSigner] = await ethers.getSigners();
    agent = agentSigner.address;
    action = actionSigner.address;

    const PermissionManager = await ethers.getContractFactory("PermissionManager");
    permissionManager = await PermissionManager.deploy();
    await permissionManager.waitForDeployment();
  });

  it("returns false by default", async function () {
    expect(await permissionManager.isAllowed(agent, action)).to.equal(false);
  });

  it("grants permission correctly", async function () {
    await permissionManager.grantPermission(agent, action);
    expect(await permissionManager.isAllowed(agent, action)).to.equal(true);
  });

  it("revokes permission correctly", async function () {
    await permissionManager.grantPermission(agent, action);
    await permissionManager.revokePermission(agent, action);
    expect(await permissionManager.isAllowed(agent, action)).to.equal(false);
  });
});
