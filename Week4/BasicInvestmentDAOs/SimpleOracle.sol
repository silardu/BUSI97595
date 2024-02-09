pragma solidity ^0.8.0;

contract SimpleOracle {
    uint public nftPrice;

    function updateNFTPrice(uint _price) public {
        nftPrice = _price;
    }

    function getNFTPrice() public view returns (uint) {
        return nftPrice;
    }
}