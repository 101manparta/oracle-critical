pragma solidity ^0.8.20;

import "./Lending.sol";

contract Liquidation {
    Lending public lending;

    constructor(address _lending) {
        lending = Lending(_lending);
    }

    function liquidate(address user) external {
        require(lending.getHealthFactor(user) < 1e18, "Healthy position");

        // logika sederhana (tidak produksi)
        // reset posisi sebagai simulasi
    }
}
