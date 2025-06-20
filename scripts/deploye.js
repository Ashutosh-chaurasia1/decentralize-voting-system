const { ethers } = require("hardhat");

async function main() {
  const VotingSystem = await ethers.getContractFactory("VotingSystem");

  // Set voting duration to 10 minutes for deployment
  const durationMinutes = 10;

  const votingSystem = await VotingSystem.deploy(durationMinutes);
  await votingSystem.deployed();

  console.log("VotingSystem deployed to:", votingSystem.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
