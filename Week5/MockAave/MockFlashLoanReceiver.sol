// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MockAavePool.sol"; // Adjust the import path as necessary

contract FlashLoanReceiver is IFlashLoanReceiver {
    IERC20 public token;
    address public pool;

    constructor(address tokenAddress, address poolAddress) {
        token = IERC20(tokenAddress);
        pool = poolAddress;
    }

    // Aave's IFlashLoanReceiver interface implementation
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 fee,
        bytes calldata params
    ) external override returns (bool) {
        // Logic to use the flash loan goes here
        // Example: arbitrage, collateral swap, etc.

        // Repay the flash loan + fee
        uint256 totalRepayment = amount + fee;
        require(token.approve(address(pool), totalRepayment), "Approval for repayment failed");
        return true;
    }

    // Function to trigger a flash loan
    function initiateFlashLoan(address asset, uint256 amount) public {
        bytes memory params = ""; // Additional data if needed
        MockAaveLendingPool(pool).flashLoan(address(this), asset, amount, params);
    }
}
