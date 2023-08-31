//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "./ERC6551Registry.sol";
import "./CoinToken.sol";
import "./Ingredient.sol";

contract FoodScramble {
  ERC6551Registry public registry;
  CoinToken public coin;
  Ingredient public ingredient;

  address public immutable owner;
  Box[] public grid;
  mapping(address => address) public tbaList;
  mapping(address => uint256) public player;
  
  struct Box {
    uint256 id;
    string typeGrid;
    uint256 ingredientType;
    uint256 numberOfPlayers;
  }

  event RollResult(address player, uint256 num);

  constructor(address _owner, address _registryAddress, address _tokenAddress, address _ingredientAddress) {
    owner = _owner;
    registry = ERC6551Registry(_registryAddress);
    coin = CoinToken(_tokenAddress);
    ingredient = Ingredient(_ingredientAddress);

    for (uint256 id = 0; id < 5; id++) {
      grid.push(Box(id, "Bread", 0, 0));
    }

    for (uint256 id = 5; id < 10; id++) {
      grid.push(Box(id, "Meat", 1, 0));
    }

    for (uint256 id = 10; id < 15; id++) {
      grid.push(Box(id, "Lettuce", 2, 0));
    }

    for (uint256 id = 15; id < 20; id++) {
      grid.push(Box(id, "Tomato", 3, 0));
    }
  }

  function getGrid() public view returns (Box[] memory){
    return grid;
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

    grid[0].numberOfPlayers += 1;
    coin.mint(newTBA, 100 * 10 ** 18);
  }

  function movePlayer() public {
    address tba = tbaList[msg.sender];
    grid[player[tba]].numberOfPlayers -= 1;
    uint256 randomNumber = uint256(keccak256(abi.encode(block.timestamp, tba))) % 5;
    player[tba] += randomNumber + 1;

    if (player[tba] >= 20) {
      player[tba] = 0;
      grid[0].numberOfPlayers += 1;
    }
    else {
      grid[player[tba]].numberOfPlayers += 1;
    }

    emit RollResult(tba, randomNumber);
  }

  function buyIngredient() public {
    address tba = tbaList[msg.sender];
    ingredient.mintIngredient(tba, grid[player[tba]].ingredientType);
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
