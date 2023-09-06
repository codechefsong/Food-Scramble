//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "./ERC6551Registry.sol";
import "./BreadToken.sol";
import "./MeatToken.sol";
import "./LettuceToken.sol";
import "./CoinToken.sol";
import "./FoodNFT.sol";

contract FoodScramble {
  ERC6551Registry public registry;
  BreadToken public bread;
  MeatToken public meat;
  LettuceToken public lettuce;
  CoinToken public tomato;
  FoodNFT public hamburger;

  address public immutable owner;
  Box[] public grid;
  mapping(address => address) public tbaList;
  mapping(address => uint256) public player;
  mapping(address => bool) public canBuy;
  
  struct Box {
    uint256 id;
    string typeGrid;
    uint256 ingredientType;
    uint256 numberOfPlayers;
  }

  event RollResult(address player, uint256 num);

  constructor(address _owner, address _registryAddress, address _breadAddress, address _meatAddress, address _lettuceAddress, address _tomatoAddress, address _hamburgerAddress) {
    owner = _owner;
    registry = ERC6551Registry(_registryAddress);
    bread = BreadToken(_breadAddress);
    meat = MeatToken(_meatAddress);
    lettuce = LettuceToken(_lettuceAddress);
    tomato = CoinToken(_tomatoAddress);
    hamburger = FoodNFT(_hamburgerAddress);

    grid.push(Box(0, "Home", 99, 0));

    for (uint256 id = 1; id < 5; id++) {
      grid.push(Box(id, "Bread", 0, 0));
    }

    grid.push(Box(5, "Rail", 98, 0));

    for (uint256 id = 6; id < 10; id++) {
      grid.push(Box(id, "Meat", 1, 0));
    }

    for (uint256 id = 10; id < 15; id++) {
      grid.push(Box(id, "Lettuce", 2, 0));
    }

    grid.push(Box(15, "Rail", 98, 0));

    for (uint256 id = 16; id < 20; id++) {
      grid.push(Box(id, "Tomato", 3, 0));
    }
  }

  function getGrid() public view returns (Box[] memory){
    return grid;
  }

  function getMyFoods(address _owner) public view returns (uint256[] memory){
    address tba = tbaList[_owner];
    return hamburger.getMyFoods(tba);
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

    if (grid[player[tba]].ingredientType <= 3) {
      canBuy[tba] = true;
    }

    emit RollResult(tba, randomNumber);
  }

  function buyIngredient() public {
    address tba = tbaList[msg.sender];
    require(canBuy[tba], "You already brought this ingredient");
    Box memory currentSpot = grid[player[tba]];

    if (currentSpot.ingredientType == 0) bread.mint(tba, 1 * 10 ** 18);
    else if (currentSpot.ingredientType == 1) meat.mint(tba, 1 * 10 ** 18);
    else if (currentSpot.ingredientType == 2)lettuce.mint(tba, 1 * 10 ** 18);
    else if (currentSpot.ingredientType == 3)tomato.mint(tba, 1 * 10 ** 18);

    // for testing
    bread.mint(tba, 1 * 10 ** 18);
    meat.mint(tba, 1 * 10 ** 18);
    lettuce.mint(tba, 1 * 10 ** 18);
    tomato.mint(tba, 1 * 10 ** 18);

    canBuy[tba] = false;
  }

  function travelRail() public {
    address tba = tbaList[msg.sender];
    Box memory currentSpot = grid[player[tba]];
    require(currentSpot.ingredientType == 98, "You cannot use this rail");

    grid[player[tba]].numberOfPlayers -= 1;

    if (player[tba] == 5) {
      player[tba] = 15;
      grid[15].numberOfPlayers += 1;
    }
    else {
      player[tba] = 5;
      grid[5].numberOfPlayers += 1;
    }
  }

  function mintFoodNFT() public {
    address tba = tbaList[msg.sender];
    // require(bread.balanceOf[tba] > 0, "You need more bread");
    // require(meat.balanceOf[tba] > 0, "You need more meat");
    // require(lettuce.balanceOf[tba] > 0, "You need more lettuce");
    // require(tomato.balanceOf[tba] > 0, "You need more tomato");

    bread.burn(tba, 1 * 10 ** 18);
    meat.burn(tba, 1 * 10 ** 18);
    lettuce.burn(tba, 1 * 10 ** 18);
    tomato.burn(tba, 1 * 10 ** 18);

    hamburger.mintFood(tba, "h");
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
