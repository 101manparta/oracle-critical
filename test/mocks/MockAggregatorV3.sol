// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MockAggregatorV3 {
    int256 private answer;
    uint8 public decimals = 8;
    uint80 private roundId = 1;
    uint256 private updatedAt;

    function setPrice(int256 _answer, uint256 _updatedAt) external {
        answer = _answer;
        updatedAt = _updatedAt;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (
            roundId,
            answer,
            updatedAt,
            updatedAt,
            roundId
        );
    }
}
