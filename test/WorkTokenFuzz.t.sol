// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WorkToken.sol";

contract WorkTokenFuzzTest is Test{
    WorkToken token;
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    function setUp() public{
        token = new WorkToken(1000);
    }

     function testFuzzBalanceOf(address wallet) public{
        uint256 balanceWallet = token.balanceOf(wallet);
        assertEq(token.balanceOf(wallet), balanceWallet);
    }

    function testFuzzTransfer(address recipient, uint256 amount) public{
        vm.assume(amount <= token.balanceOf(address(this)));
        vm.assume(amount <= token.totalSupply());

        uint256 initBalanceRecipient = token.balanceOf(recipient);
        assertTrue(token.transfer(recipient, amount));
        assertEq(token.balanceOf(recipient), initBalanceRecipient+amount);
    }

    function testFuzzTransferFrom(address to, uint256 amount) public{
        vm.assume(amount <= token.balanceOf(address(this)));
        vm.assume(to != address(0));

        assertTrue(token.approve(alice, amount));
        assertEq(token.allowance(address(this), alice), amount);
        vm.prank(alice);
        assertTrue(token.transferFrom(address(this), to, amount));
        assertEq(token.balanceOf(to), amount);
    }

    function testFuzzApprove(address spender, uint256 amount) public{
        vm.assume(spender != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));
        vm.assume(amount <= token.totalSupply());

        assertTrue(token.approve(spender, amount));
    }

    function testFuzzAllowance(address spender) public{
        vm.assume(spender != address(0));

        assertTrue(token.approve(spender, 100));
        assertEq(token.allowance(address(this), spender), 100);
    }

    function testFuzzIncreaseAllowance(address spender, uint256 amount) public{
        vm.assume(spender != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));

        assertTrue(token.approve(spender, amount));
        assertEq(token.allowance(address(this), spender), amount);
        assertTrue(token.increaseAllowance(spender, 100));
        assertEq(token.allowance(address(this), spender), amount + 100);
    }

    function testFuzzDecreaseAllowance(address spender, uint256 amount) public{
        vm.assume(spender != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));
        vm.assume(amount > 0);

        assertTrue(token.approve(spender, amount));
        assertEq(token.allowance(address(this), spender), amount);
        assertTrue(token.decreaseAllowance(spender, 1));
        assertEq(token.allowance(address(this), spender), amount - 1);
    }


    // TESTS FAILS
    function testFailFuzzTransferNotBalance(address recipient, uint256 amount) public{
        vm.assume(recipient != address(0));
        vm.assume(amount >= token.balanceOf(address(this)));
        assertTrue(token.transfer(recipient, amount));
    }

    function testFailFuzzApproveNotBalance(address spender, uint256 amount) public{
        vm.assume(spender != address(0));
        vm.assume(amount >= token.balanceOf(address(this)));

        assertTrue(token.approve(spender, amount));
    }

    function testFailFuzzTransferFromNotBalanace(address from, address to, uint256 amount) public{
        from = address(this);
        vm.assume(to!=address(0));
        vm.assume(amount >= token.balanceOf(address(this)));

        assertTrue(token.approve(bob, amount));
        vm.prank(bob);
        assertTrue(token.transferFrom(from, to, amount));
    }

//    function testFailFuzzTransferFromNotApprove(address from, address to, uint256 amount) public{
//         from = address(this);
//         vm.assume(to != address(0));
//         vm.assume(amount <= token.balanceOf(address(this)));

//         vm.prank(bob);
//         assertTrue(token.transferFrom(from, to, amount));
//     } 

    function testFailFuzzDecreaseAllowanceZeroBalance(address spender, uint256 amount) public{
        vm.assume(spender!=address(0));
        vm.assume(amount <= token.balanceOf(address(this)));

        assertTrue(token.approve(spender, amount));
        uint256 amountNegative = amount - amount - 1;
        assertTrue(token.decreaseAllowance(spender, amountNegative));
    }
}