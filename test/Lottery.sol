// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Lottery.sol";
import "../src/WorkToken.sol";

contract LoteriaTest is Test {
    Loteria lot;
    WorkToken token;

    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);
    address clara = vm.addr(0x3);

    function setUp() public {
      token = new WorkToken(2000);
      lot = new Loteria(address(token));
    }

    function testFuzzBuyTicket(uint256 amount) public{
      amount = 500;
      assertTrue(token.approve(address(lot), 500));
      lot.statusOpen();
      assertTrue(lot.buyTicket(amount));
      assertEq(token.balanceOf(address(this)), 1500);
      assertEq(token.balanceOf(address(lot)), 500);
    }

    function testGiftWinner() public {
      assertEq(token.balanceOf(address(this)), 2000);
      assertTrue(token.approve(address(lot), 500));
      assertTrue(token.transfer(alice, 500));
      lot.statusOpen();
      assertTrue(lot.buyTicket(500));

      vm.startPrank(alice);
      assertTrue(token.approve(address(lot), 500));
      assertTrue(lot.buyTicket(500));
      vm.stopPrank();

      assertEq(token.balanceOf(address(lot)), 1000);
      assertTrue(lot.giftWinner());
      
      assertEq(token.balanceOf(address(lot)), 0);
    }

    function testGetValueGift() public{
      assertTrue(token.approve(address(lot),500));
      lot.statusOpen();
      assertTrue(lot.buyTicket(500));
      assertEq(lot.getValueGift(), 500);
    }

    //TESTS FAILS
    function testFailFuzzBuyTicketStatusCLOSED(uint256 amount) public{
      amount = 500;
      assertTrue(token.approve(address(lot),amount));
      assertTrue(lot.buyTicket(amount));
    }

    function testFailFuzzBuyTicketOtherValue(uint256 amount) public{
      amount = 400;
      assertTrue(token.approve(address(lot), amount));
      lot.statusOpen();
      assertTrue(lot.buyTicket(amount));
    }

    function testFailFuzzGiftWinnerStatusCLOSED(uint256 amount) public{
      amount = 500;
      assertTrue(token.approve(address(lot), amount));
      assertTrue(lot.buyTicket(amount));
      assertTrue(lot.giftWinner());
    }

    function testFailFuzzGiftWinnerNotOwner(uint256 amount) public{
      amount = 500;
      assertTrue(token.approve(address(lot), amount));
      lot.statusOpen();
      assertTrue(lot.buyTicket(amount));
      vm.prank(alice);
      assertTrue(lot.giftWinner());
    }

    function testFailFuzzGetValueGiftStatusCLOSED(uint256 amount) public{
      amount = 500;
      assertTrue(token.approve(address(lot), amount));
      lot.getValueGift();
    }
}
