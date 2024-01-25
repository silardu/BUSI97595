// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ;

// A simplified version of a DeFi lending contract
contract DeFiLending {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowBalances;
    uint256 public constant interestRate = 5; // 5% per year
    
    // Deposit funds into the protocol
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        // Emit an event or add additional logic
    }
    
    // Borrow against the user's deposits
    function borrow(uint256 amount) external {
        require(balances[msg.sender] * 150 / 100 >= amount, "Insufficient collateral");
        borrowBalances[msg.sender] += amount;
        payable(msg.sender).transfer(amount);
        // Emit an event or add additional logic
    }
    
    // Repay the borrowed amount
    function repay() external payable {
        borrowBalances[msg.sender] -= msg.value;
        // Calculate interest and update balances accordingly
        // Emit an event or add additional logic
    }
    
    // Assume annual block count of ~2.3 million for Ethereum (~13 sec block time)
    function calculateInterest(address user) public view returns (uint256) {
        // Simplified interest calculation without compounding
        uint256 interest = borrowBalances[user] * interestRate / 100 / 2.3e6 * block.number;
        return interest;
    }
}
