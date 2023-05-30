// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  //Premium contract deploy script
  const Premium = await hre.ethers.getContractFactory("Premium");
  const premium = await Premium.deploy();

  await premium.deployed();

  console.log(`Premium deployed to ${premium.address}`);

  const Conciousness = await hre.ethers.getContractFactory("Consciousness");
  const conciousness = await Conciousness.deploy(premium.address);

  await conciousness.deployed();

  console.log(`Conciousness deployed to ${conciousness.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
