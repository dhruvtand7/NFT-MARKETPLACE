const hre = require("hardhat");

async function main() {
  const SkinNFT = await ethers.getContractFactory("contracts/SkinNFT.sol:SkinNFT");
  const skinNFT = await SkinNFT.deploy();
  await skinNFT.waitForDeployment();
  console.log("SkinNFT deployed to:", await skinNFT.getAddress());

  const Marketplace = await ethers.getContractFactory("contracts/MarketPlace.sol:Marketplace");
  const marketplace = await Marketplace.deploy(await skinNFT.getAddress());
  await marketplace.waitForDeployment();
  console.log("Marketplace deployed to:", await marketplace.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
