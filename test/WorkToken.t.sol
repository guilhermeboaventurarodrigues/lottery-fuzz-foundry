// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WorkToken.sol";

contract WorkTokenTest is Test{

    WorkToken token;
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    function setUp() public{
        token = new WorkToken(1000);
    }

    function testTokenName() public{
        assertEq(token.name(), "WorkToken");
    }

    function testTokenSymbol() public{
        assertEq(token.symbol(), "WTK");
    }

    function testTokenDecimals() public{
        assertEq(token.decimals(), 18);
    }

    function testTotalSupply() public{
        assertEq(token.totalSupply(), 1000);
    }
}
