pragma solidity ^0.8.0;

interface IWETH {
    function deposit() external payable;
    function approve(address spender, uint amount) external returns (bool);
}

interface IVaultManager {
    function openVault() external returns (uint256 vaultId);
    function depositAndGenerateDAI(uint256 vaultId, uint256 ethAmount, uint256 daiAmount);
}

interface IDAI {
    function balanceOf(address owner) external view returns (uint256);
}

contract EthToDAIConverter {
    IWETH public weth;
    IVaultManager public vaultManager;
    IDAI public dai;

    constructor(address _weth, address _vaultManager, address _dai) {
        weth = IWETH(_weth);
        vaultManager = IVaultManager(_vaultManager);
        dai = IDAI(_dai);
    }

    function depositETHAndGenerateDAI(uint256 daiAmount) external payable {
        weth.deposit{value: msg.value}();
        weth.approve(address(vaultManager), msg.value);
        uint256 vaultId = vaultManager.openVault();
        vaultManager.depositAndGenerateDAI(vaultId, msg.value, daiAmount);
        uint256 daiGenerated = dai.balanceOf(address(this));
        require(dai.transfer(msg.sender, daiGenerated), "DAI transfer failed");
    }
}