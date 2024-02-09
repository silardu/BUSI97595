// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ;

contract SimpleAMM {
    uint public constant K = 50_000; // Constant product
    uint public reserveTokenA;
    uint public reserveTokenB;

    function addLiquidity(uint tokenAAmount, uint tokenBAmount) public {
        reserveTokenA += tokenAAmount;
        reserveTokenB += tokenBAmount;
        // LP tokens would be minted here proportional to the contribution
    }

    function getQuote(uint inputAmount, uint inputReserve, uint outputReserve) public pure returns (uint) {
        require(inputReserve * outputReserve > K, "Invalid reserves");
        uint inputAmountWithFee = inputAmount * 997;
        uint numerator = inputAmountWithFee * outputReserve;
        uint denominator = (inputReserve * 1000) + inputAmountWithFee;
        return numerator / denominator;
    }

    function swapTokenAForTokenB(uint tokenAAmount) public {
        uint tokenBAmount = getQuote(tokenAAmount, reserveTokenA, reserveTokenB);
        reserveTokenA += tokenAAmount;
        reserveTokenB -= tokenBAmount;
        // Transfer Token B to the swapper
    }
    
    // Additional functions for swapping Token B for A, removing liquidity, etc., would also be included
}

      