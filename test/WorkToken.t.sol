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

    function testFuzzBalanceOf(address wallet) public{
        wallet = address(this);
        assertEq(token.balanceOf(wallet), 1000);
    }

    function testFuzzTransfer(address recipient, uint256 amount) public{
        recipient = alice;
        amount = 500;
        assertTrue(token.transfer(recipient, amount));
        assertEq(token.balanceOf(recipient), 500);
    }

    function testFuzzTransferFrom(address from, address to, uint256 amount) public{
        from = address(this);
        to = alice;
        amount = 500;
        assertEq(token.balanceOf(from), 1000);
        assertEq(token.balanceOf(to), 0);
        assertTrue(token.approve(bob, amount));
        vm.prank(bob);
        assertTrue(token.transferFrom(from, to, amount));
        assertEq(token.balanceOf(to), 500);
        assertEq(token.balanceOf(from), 500);
    }

    function testFuzzApprove(address spender, uint256 amount) public{
        spender = alice;
        amount = 500;
        assertTrue(token.approve(spender, amount));
    }

    function testFuzzAllowance(address ownerToken, address spender) public{
        ownerToken = address(this);
        spender = alice;
        assertTrue(token.approve(spender, 500));
        assertEq(token.allowance(ownerToken, spender), 500);
    }

    function testFuzzIncreaseAllowance(address spender, uint256 amount) public{
        spender = alice;
        amount = 500;
        assertTrue(token.approve(spender, amount));
        assertEq(token.allowance(address(this), spender), 500);
        assertTrue(token.increaseAllowance(spender, 100));
        assertEq(token.allowance(address(this), spender), 600);
    }

    function testFuzzDecreaseAllowance(address spender, uint256 amount) public{
        spender = alice;
        amount = 500;
        assertTrue(token.approve(spender, amount));
        assertEq(token.allowance(address(this), spender), amount);
        assertTrue(token.decreaseAllowance(spender, 100));
        assertEq(token.allowance(address(this), spender), 400);
    }


    // TESTS FAILS
    function testFailFuzzTransferNotBalance(address recipient, uint256 amount) public{
        recipient = alice;
        amount= 1001;
        assertTrue(token.transfer(recipient, amount));
    }

    function testFailFuzzApproveNotBalance(address spender, uint256 amount) public{
        spender = alice;
        amount =  1001;
        assertTrue(token.approve(spender, amount));
    }

    function testFailFuzzTransferFromNotBalanace(address from, address to, uint256 amount) public{
        from = address(this);
        to = alice;
        amount=1001;
        assertTrue(token.approve(bob, 1000));
        vm.prank(bob);
        assertTrue(token.transferFrom(from, to, amount));
    }

    function testFailFuzzTransferFromNotApprove(address from, address to, uint256 amount) public{
        from = address(this);
        to = alice;
        amount = 1000;
        vm.prank(bob);
        assertTrue(token.transferFrom(from, to, amount));
    }

    function testFailFuzzDecreaseAllowanceZeroBalance(address spender, uint256 amount) public{
        spender = alice;
        amount = 10;
        assertTrue(token.approve(spender, amount));
        assertTrue(token.decreaseAllowance(spender, 20));
    }
}
