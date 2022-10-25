const {ethers} = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners(); //get the account to deploy the contract

  console.log("Deploying contracts with the account:", deployer.address); 

  const Logistics = await ethers.getContractFactory("Logistics");
  const logistics = await Logistics.deploy()

  await logistics.deployed()

  console.log("Logistics deployed to:", logistics.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
