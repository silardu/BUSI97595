// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleNFT is ERC721 {
    uint256 public nextTokenId;

    constructor() ERC721("SimpleNFT", "SNFT") {}

    function mintNFT() public {
        _mint(msg.sender, nextTokenId);
        nextTokenId++;
    }
}