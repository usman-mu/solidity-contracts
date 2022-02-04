//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public owner;
    address payable[] participants;
    uint public lotteryId;
    uint public amountToParticipate = 1_000_000_000_000_000 wei;
    mapping(uint => address payable) public lotteryHistory;
    constructor(){
        lotteryId = 1;
        owner = msg.sender;
    }

    /**
    * @dev sets minimum amount of contribution to participate in lottery
    */
    function setAmountToParticipate(uint amount) public  ownerOnly {
        require(participants.length < 1);
        amountToParticipate = amount;
    }

    /**
    * @dev returns individual winner of each lottery by lottery ID
    */
    function getWinnerByLottery(uint lottery) public view returns(address payable){
        return lotteryHistory[lottery];
    }

    /**
    * @dev returns total funds participated in current lottery
    */
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    /**
    * @dev gives list of all participants in current lottery
    */
    function getParticipants() public view returns(address payable[] memory){
        return participants;
    }

    /**
    * @dev checks if participant sent enough funds to participate
    * and adds them to participants list
    */
    function enter() public payable {
        require(msg.value > amountToParticipate);
        participants.push(payable(msg.sender));
    }

    /**
    * @dev generates random number
    */
    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    /**
    * @dev makes sure caller is the owner of contract
    */
    modifier ownerOnly(){
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Picks winner and total contributed amount to winner.
     * adds winner to history
     * increases lottery id
     * resets participants array
     */
    function pickWinner() public ownerOnly{
        uint index = getRandomNumber() % participants.length;
        participants[index].transfer(address(this).balance);
        lotteryHistory[lotteryId] = participants[index];
        lotteryId++;
        participants = new address payable[](0);
    }
}
