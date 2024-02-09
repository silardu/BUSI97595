pragma solidity >=0.8.0 <0.9.0;

contract DeFiLending {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowBalances;
    mapping(address => uint256) public lastBorrowBlock;
    uint256 public constant interestRate = 5; // 5% annual interest rate

    // Define events for tracking activities
    event Deposit(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount, uint256 interest);

    // Deposit funds into the protocol
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Borrow against the user's deposits
    function borrow(uint256 amount) external {
        require(balances[msg.sender] * 150 / 100 >= amount, "Insufficient collateral");
        updateInterest(msg.sender); // Update interest before new borrow
        borrowBalances[msg.sender] += amount;
        lastBorrowBlock[msg.sender] = block.number;
        payable(msg.sender).transfer(amount);
        emit Borrow(msg.sender, amount);
    }

    // Repay the borrowed amount along with the interest
    function repay() external payable {
        updateInterest(msg.sender); // Calculate and update interest
        uint256 totalDebt = borrowBalances[msg.sender];
        require(msg.value >= totalDebt, "Repay amount less than debt");
        balances[msg.sender] += msg.value - totalDebt; // Excess goes to deposit
        borrowBalances[msg.sender] = 0;
        emit Repay(msg.sender, totalDebt, msg.value - totalDebt);
    }

    // Calculate and update interest for a user
    function updateInterest(address user) public {
        uint256 interest = calculateInterest(user);
        borrowBalances[user] += interest; // Accumulate interest to borrow balance
    }

    function calculateInterest(address user) public view returns (uint256) {
    if (lastBorrowBlock[user] == 0) return 0; // No interest if no borrow
    uint256 blocksPassed = block.number - lastBorrowBlock[user];
    // Adjust interest calculation for demonstration purposes:
    // For example, assume interestRate is now per 100 blocks instead of per year
    uint256 interestPerBlock = borrowBalances[user] * interestRate / 100 / 100; // Simplified for quick accrual
    return blocksPassed * interestPerBlock;
}
}
