const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const NFTStaking = await hre.ethers.getContractFactory("NFTStaking");
  const rewardsTokenAddress = "0xYourRewardsTokenAddress"; // Replace with your ERC20 token address
  const nftCollectionAddress = "0xYourNFTCollectionAddress"; // Replace with your ERC721 token address

  const nftStaking = await NFTStaking.deploy(rewardsTokenAddress, nftCollectionAddress);

  await nftStaking.deployed();

  console.log("NFTStaking deployed to:", nftStaking.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
