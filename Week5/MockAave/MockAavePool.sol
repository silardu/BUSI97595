// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFlashLoanReceiver {
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 fee,
        bytes calldata params
    ) external returns (bool);
}

contract MockAaveLendingPool {
    IERC20 public token;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }

    // Simulate a flash loan by lending `amount` tokens to the receiver
    function flashLoan(
        address receiver,
        address asset,
        uint256 amount,
        bytes calldata params
    ) external {
        uint256 fee = amount / 100; // Example fee: 1% of the loan amount
        require(token.transfer(receiver, amount), "Transfer failed");

        require(
            IFlashLoanReceiver(receiver).executeOperation(asset, amount, fee, params),
            "Operation failed"
        );

        uint256 totalRepayment = amount + fee;
        require(token.transferFrom(receiver, address(this), totalRepayment), "Repayment failed");
    }
}
