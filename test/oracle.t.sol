// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/PriceOracle.sol";
import "./mocks/MockAggregatorV3.sol";

contract OracleTest is Test {
    MockAggregatorV3 mock;
    PriceOracle oracle;

    function setUp() public {
        mock = new MockAggregatorV3();
        oracle = new PriceOracle(address(mock));
    }

    function testGetPriceSuccess() public {
        vm.warp(10 hours);
        mock.setPrice(2000e8, block.timestamp);

        uint256 price = oracle.getPrice();
        assertEq(price, 2000e18);
    }

    function testRevertOnStalePrice() public {
        vm.warp(10 hours);
        mock.setPrice(2000e8, block.timestamp - 2 hours);

        vm.expectRevert("STALE_PRICE");
        oracle.getPrice();
    }
}
