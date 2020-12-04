const hre = require("hardhat")
const ethers = hre.ethers

async function main() {
    // We get the contract to deploy
    const Ueth = await ethers.getContractFactory("UETH")
    const Ulocker = await ethers.getContractFactory("ULOCKER")

    const ueth = await Ueth.deploy()
    await ueth.deployed()
    console.log("ueth deployed to:", ueth.address)

    const ulocker = await Ulocker.deploy(ueth.address)
    await ulocker.deployed()
    console.log("ulocker deployed to:", ulocker.address)

    await ueth.transferUlocker(ulocker.address)
    console.log("ulocker permission on ueth transferred")
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    });
  