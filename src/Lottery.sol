import "./WorkToken.sol";
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Loteria{

    enum Status {CLOSED, OPEN}

    address[] private players;
    address private tokenAddress;
    address private owner;
    Status lotteryStatus;

    modifier isOwner{
      require(msg.sender == owner, "Sender not owner");
      _;
    }

    constructor(address token){
        owner = msg.sender;
        tokenAddress = token;
        lotteryStatus = Status.CLOSED;
    }

    event BuyTicket(address to, address from, uint256 amount);
    event NewWinner(address wallet, uint256 amount);

    function buyTicket(uint256 amount) public returns(bool){
        require(lotteryStatus == Status.OPEN, "Lottery closed");
        require(amount == 500, "Value ticket: 500 tokens");
        WorkToken(tokenAddress).transferFrom(msg.sender, address(this), amount);
        players.push(msg.sender);
        emit BuyTicket(msg.sender, address(this), amount);
        return true;
    }

    function giftWinner() public isOwner returns(bool){
        require(lotteryStatus == Status.OPEN, "Lottery closed");
        uint number = random() % players.length;
        uint balance = WorkToken(tokenAddress).balanceOf(address(this));
        address winner = players[number];
        WorkToken(tokenAddress).transfer(winner, balance);
        emit NewWinner(winner, balance);
        return true;
    }

    function getValueGift() public view returns(uint256){
        require(lotteryStatus == Status.OPEN, "Lottery closed");
        return WorkToken(tokenAddress).balanceOf(address(this));
    }

    function getPlayers() public view returns(address[] memory){
        return players;
    }

    function statusOpen() public isOwner{
        lotteryStatus = Status.OPEN;
    }

    function statusClosed() public isOwner{
        lotteryStatus = Status.CLOSED;
    }

    function getStatusLoterry() public view returns(Status){
        return lotteryStatus;
    }

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

}