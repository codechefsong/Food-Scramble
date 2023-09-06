// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FoodNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(address => uint256[]) public mynfts;
  mapping(address => uint256[]) public myFoods;

  constructor() ERC721("Food Scramble NFT", "FSN") {}

  function mintChef(address _to, string memory _tokenURI_) public returns (uint256) {
    uint256 newItemId = _tokenIds.current();
    _mint(_to, newItemId);
    _setTokenURI(newItemId, _tokenURI_);

    _tokenIds.increment();
    mynfts[_to].push(newItemId);
    return newItemId;
  }

  function mintFood(address _to, string memory _tokenURI_) public returns (uint256) {
    uint256 newItemId = _tokenIds.current();
    _mint(_to, newItemId);
    _setTokenURI(newItemId, _tokenURI_);

    _tokenIds.increment();
    myFoods[_to].push(newItemId);
    return newItemId;
  }

  function getMyNFTs(address _owner) public view returns (uint256[] memory){
    return mynfts[_owner];
  }

  function getMyFoods(address _owner) public view returns (uint256[] memory){
    return myFoods[_owner];
  }
}