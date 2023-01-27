require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

require('dotenv').config();

const { WALLET_PRIVATE_KEY } = process.env;
const { POLYGONSCAN_API_KEY } = process.env;
const { TESTE_URL } = process.env;
const { DEPLOY_URL } = process.env;
const { DEPLOY_WALLET_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.16",
      },
      {
        version: "0.8.16",
        settings: {},
      },
    ],
  },
  networks: {
    mumbai: {
      url: TESTE_URL,
      accounts: [`0x${WALLET_PRIVATE_KEY}`],
    },
    mainet: {
      url: DEPLOY_URL,
      accounts: [`0x${DEPLOY_WALLET_PRIVATE_KEY}`],
    },
    localhost: {
      url: process.env.LOCALHOST_URL || '',
      accounts:
        process.env.LOCAL_PRIVATE_KEY !== undefined
          ? [process.env.LOCAL_PRIVATE_KEY]
          : [],
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
};
