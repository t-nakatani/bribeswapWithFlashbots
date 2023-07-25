require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0"
      },
      {
        version: "0.8.18"
      }
    ]
  },
  networks: {
    goerli: {
      url: process.env.JSON_RPC,
      accounts: [process.env.PRIVATE_KEY],
    }
  },
};
