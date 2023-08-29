//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "./ERC6551Registry.sol";

contract FoodScramble {
  // State Variables
  ERC6551Registry public registry;

  address public immutable owner;
  mapping(address => address) public tbaList;

  // Constructor: Called once on contract deployment
  // Check packages/hardhat/deploy/00_deploy_your_contract.ts
  constructor(address _owner, address _registryAddress) {
    owner = _owner;
    registry = ERC6551Registry(_registryAddress);
  }

  function createTokenBoundAccount(
    address _implementation,
    uint256 _chainId,
    address _tokenContract,
    uint256 _tokenId,
    uint256 _salt,
    bytes calldata _initData
  ) external {
    address newTBA = registry.createAccount(_implementation, _chainId, _tokenContract, _tokenId, _salt, _initData);
    tbaList[msg.sender] = newTBA;
  }

  // Modifier: used to define a set of rules that must be met before or after a function is executed
  // Check the withdraw() function
  modifier isOwner() {
    // msg.sender: predefined variable that represents address of the account that called the current function
    require(msg.sender == owner, "Not the Owner");
    _;
  }

  /**
   * Function that allows the owner to withdraw all the Ether in the contract
   * The function can only be called by the owner of the contract as defined by the isOwner modifier
   */
  function withdraw() public isOwner {
    (bool success, ) = owner.call{ value: address(this).balance }("");
    require(success, "Failed to send Ether");
  }

  /**
   * Function that allows the contract to receive ETH
   */
  receive() external payable {}
}
