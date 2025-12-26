// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceOracle {
    AggregatorV3Interface public priceFeed;
    uint256 public constant STALE_TIMEOUT = 1 hours;

    constructor(address _feed) {
        priceFeed = AggregatorV3Interface(_feed);
    }

    function getPrice() public view returns (uint256) {
        (
            ,
            int256 answer,
            ,
            uint256 updatedAt,

        ) = priceFeed.latestRoundData();

        require(answer > 0, "INVALID_PRICE");
        require(updatedAt > 0, "NO_TIMESTAMP");
        require(updatedAt <= block.timestamp, "FUTURE_TIMESTAMP");
        require(block.timestamp <= updatedAt + STALE_TIMEOUT, "STALE_PRICE");

        return uint256(answer) * 1e10;
    }
}
