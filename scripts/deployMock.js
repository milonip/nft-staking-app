const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy MockERC20
  const MockERC20 = await hre.ethers.getContractFactory("MockERC20");
  const mockERC20 = await MockERC20.deploy();
  await mockERC20.deployed();
  console.log("MockERC20 deployed to:", mockERC20.address);

  // Deploy MockERC721
  const MockERC721 = await hre.ethers.getContractFactory("MockERC721");
  const mockERC721 = await MockERC721.deploy();
  await mockERC721.deployed();
  console.log("MockERC721 deployed to:", mockERC721.address);

  // Deploy NFTStaking with the addresses of MockERC20 and MockERC721
  const NFTStaking = await hre.ethers.getContractFactory("NFTStaking");
  const nftStaking = await NFTStaking.deploy(mockERC20.address, mockERC721.address);
  await nftStaking.deployed();
  console.log("NFTStaking deployed to:", nftStaking.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
