import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
const config = {
  solidity: "0.8.20",
  networks: {
    hardhat: {},
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.DEPLOYER_PRIVATE_KEY],
    },
  },
};

export default config;
