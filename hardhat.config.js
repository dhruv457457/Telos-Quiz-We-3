require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
   solidity: "0.8.11",
   defaultNetwork: "telos",  // Make sure to use the correct network name here
   networks: {
      hardhat: {},
      telos: {  // Correct network name
         url: API_URL,
         accounts: [`0x${PRIVATE_KEY}`],
         gas: 2100000,  // Adjusted gas value
         gasPrice: 800000000000,  // Set gas price
      }
   },
}
