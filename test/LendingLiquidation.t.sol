// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/PriceOracle.sol";
import "./mocks/MockAggregatorV3.sol";

contract LendingTest is Test {
    MockAggregatorV3 mock;
    PriceOracle oracle;

    function setUp() public {
        vm.warp(10 hours);
        mock = new MockAggregatorV3();
        oracle = new PriceOracle(address(mock));
        mock.setPrice(2000e8, block.timestamp);
    }

    function testDepositAndBorrow() public {
        uint256 price = oracle.getPrice();
        assertEq(price, 2000e18);
    }

    function testBorrowFailsIfPriceStale() public {
        vm.warp(10 hours);
        mock.setPrice(2000e8, block.timestamp - 2 hours);

        vm.expectRevert("STALE_PRICE");
        oracle.getPrice();
    }
}
