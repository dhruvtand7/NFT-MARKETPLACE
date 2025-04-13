require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545", // Ganache default
      accounts: [
        "0x4f0fe2e084dcaee6590cbfd2656b73b6fde0070193e04dfddd582cfe635b2e05" // without '0x' if it doesn't work, try both
      ]
    }
  }
};
