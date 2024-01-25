// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0 ;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TimeLockedWallet {
    address public owner;
    address public beneficiary;
    uint256 public unlockDate;
    uint256 public createdAt;
    AggregatorV3Interface internal priceFeed;

    constructor(
        address _owner,
        address _beneficiary,
        uint256 _unlockDate,
        address _priceFeed
      ) {
        owner = _owner;
        beneficiary = _beneficiary;
        unlockDate = _unlockDate;
        createdAt = block.timestamp;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function deposit() external payable {}

    function withdraw() external {
        require(block.timestamp >= unlockDate, "Funds are locked");
        require(msg.sender == beneficiary, "Not authorized");
        require(getLatestPrice() > 2000 * 10**8, "Price below threshold"); // Assuming the threshold is 2000 USD
        payable(beneficiary).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function getLatestPrice() public view returns (int) {
        (, int price,,,) = priceFeed.latestRoundData();
        return price;
    }
}
