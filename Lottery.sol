//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public owner;
    address payable[] participants;
    uint public lotteryId;
    uint public amountToParticipate = .1 ether;
    mapping(uint => address payable) public lotteryHistory;
    constructor(){
        lotteryId = 1;
        owner = msg.sender;
    }
    function setAmountToParticipate(uint amount) public  ownerOnly {
        amountToParticipate = amount;
    }
    function getWinnerByLottery(uint lottery) public view returns(address payable){
        return lotteryHistory[lottery];
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function getParticipants() public view returns(address payable[] memory){
        return participants;
    }
    function enter() public payable {
        require(msg.value >= amountToParticipate);
        participants.push(payable(msg.sender));
    }
    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }
    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }
    function pickWinner() public ownerOnly{
        uint index = getRandomNumber() % participants.length;
        participants[index].transfer(address(this).balance);
        lotteryHistory[lotteryId] = participants[index];
        lotteryId++;
        participants = new address payable[](0);
    }
}
