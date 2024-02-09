// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SilaToken is ERC20 {
    constructor() ERC20("SilaToken", "ST") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}