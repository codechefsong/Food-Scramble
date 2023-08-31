// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Ingredient is ERC1155 {
    uint256 public constant Bread  = 1;
    uint256 public constant Meat = 2;
    uint256 public constant Lettuce = 3;
    uint256 public constant Tomato = 4;

    constructor() ERC1155("") {
    }

    function mintIngredient(address _account, uint256 _id) public {
        if (_id == 0) _mint(_account, Bread, 1, "");
        else if (_id == 1) _mint(_account, Meat, 1, "");
        else if (_id == 2) _mint(_account, Lettuce, 1, "");
        else if (_id == 3) _mint(_account, Tomato, 1, "");
    }
}