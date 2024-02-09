pragma solidity ^0.8.0;

import "./SimpleOracle.sol";

contract InvestmentContract {
    SimpleOracle public oracle;

    constructor(address _oracleAddress) {
        oracle = SimpleOracle(_oracleAddress);
    }

    function shouldInvest() public view returns (bool) {
        uint nftPrice = oracle.getNFTPrice();
        // Basic investment logic based on NFT price
        if (nftPrice > 1000 ether) { // Example threshold
            return true;
        }
        return false;
    }
}