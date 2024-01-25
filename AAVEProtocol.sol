// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ;

// Interface for the Aave lending pool
interface ILendingPool {
    function flashLoan(
        address receiverAddress,
        address asset,
        uint256 amount,
        bytes calldata params
    ) external;
}

// Interface for the receiver of the flash loan
interface IFlashLoanReceiver {
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool);
}

// Your contract needs to implement the IFlashLoanReceiver interface
contract FlashLoanReceiver is IFlashLoanReceiver {
    ILendingPool lendingPool;
    address operator;

    constructor(address _lendingPoolAddress) {
        lendingPool = ILendingPool(_lendingPoolAddress);
        operator = msg.sender;
    }

    // This function is called after your contract has received the flash loaned amount
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Your logic goes here.
        // For example, arbitrage, swapping collaterals, etc.
        
        // After your operations are complete, you need to repay the flash loan
        uint256 amountOwing = amount + premium;
        require(IERC20(asset).approve(address(lendingPool), amountOwing), "Approval failed");

        return true;
    }

    // Function to initiate a flash loan
    function initiateFlashLoan(address asset, uint256 amount) external {
        require(msg.sender == operator, "Only operator can initiate");

        bytes memory params = ""; // Add any parameters you wish to pass to executeOperation
        lendingPool.flashLoan(address(this), asset, amount, params);
    }
}

// You must also have the ERC20 token interface to interact with the token contract
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

