// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTStaking {
    IERC20 public rewardsToken;
    IERC721 public nftToken;

    mapping(address => uint256[]) public stakedNFTs;
    mapping(address => uint256) public rewards;

    constructor(IERC20 _rewardsToken, IERC721 _nftToken) {
        rewardsToken = _rewardsToken;
        nftToken = _nftToken;
    }

    function stakeNFT(uint256 tokenId) external {
        nftToken.transferFrom(msg.sender, address(this), tokenId);
        stakedNFTs[msg.sender].push(tokenId);
    }

    function unstakeNFT(uint256 tokenId) external {
        require(isStakedByUser(msg.sender, tokenId), "NFT not staked by user");

        uint256 index = findIndex(stakedNFTs[msg.sender], tokenId);
        stakedNFTs[msg.sender][index] = stakedNFTs[msg.sender][stakedNFTs[msg.sender].length - 1];
        stakedNFTs[msg.sender].pop();

        nftToken.transferFrom(address(this), msg.sender, tokenId);
    }

    function claimRewards() external {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
    }

    function isStakedByUser(address user, uint256 tokenId) internal view returns (bool) {
        uint256[] memory stakedTokens = stakedNFTs[user];
        for (uint256 i = 0; i < stakedTokens.length; i++) {
            if (stakedTokens[i] == tokenId) {
                return true;
            }
        }
        return false;
    }

    function findIndex(uint256[] memory array, uint256 value) internal pure returns (uint256) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return i;
            }
        }
        revert("Value not found in array");
    }
}
