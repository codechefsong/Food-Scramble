//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MeatToken is ERC20 {
    constructor() ERC20("Meat", "M") {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}