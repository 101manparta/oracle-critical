pragma solidity ^0.8.20;

import "./PriceOracle.sol";

contract Lending {
    PriceOracle public oracle;

    mapping(address => uint256) public collateral;
    mapping(address => uint256) public debt;

    uint256 public constant LIQUIDATION_THRESHOLD = 80; // %

    constructor(address _oracle) {
        oracle = PriceOracle(_oracle);
    }

    function deposit() external payable {
        collateral[msg.sender] += msg.value;
    }

    function borrow(uint256 amount) external {
        require(getHealthFactor(msg.sender) >= 1e18, "Undercollateralized");
        debt[msg.sender] += amount;
    }

    function getHealthFactor(address user) public view returns (uint256) {
        uint256 price = oracle.getPrice(); // USD
        uint256 collateralValue = collateral[user] * price;

        if (debt[user] == 0) return type(uint256).max;

        return (collateralValue * LIQUIDATION_THRESHOLD / 100) / debt[user];
    }
}
