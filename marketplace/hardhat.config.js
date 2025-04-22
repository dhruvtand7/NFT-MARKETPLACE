require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    localhost: {
      url: "http://127.0.0.1:7545", // Ganache default
      accounts: [
        "0x412ecd7364c8e559c553bebaaf5eed4ed55d7efaca740bc2a6e1cc73f75a20b1"
      ]
    },
    ganache: {
      url: "http://127.0.0.1:7545", // Ganache default
      accounts: [
        "0x412ecd7364c8e559c553bebaaf5eed4ed55d7efaca740bc2a6e1cc73f75a20b1"
      ]
    }
  }
};
