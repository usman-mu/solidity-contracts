//SPDX-License-Identifier:MIT
pragma solidity 0.8.11;


contract VendingMachine{

    address public owner;
    mapping(string => uint) public items;
    mapping(address => mapping(string => uint)) public itemBalances;

    constructor(){
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
         require(owner == msg.sender, "Only the only can call this function");
         _;

    }
    function setPrice(string memory item, uint price) public onlyOwner{
        items[item] = price;
    }
    function addSupply(string memory itemName, uint itemPrice, uint quantity) public onlyOwner{
       items[itemName] = itemPrice;
       itemBalances[address(this)][itemName] = quantity;
    }
    function restock(string memory item, uint amount) public onlyOwner{
        itemBalances[address(this)][item] += amount;
    }
    function purchase(string memory item, uint amount) public payable{
         require(msg.value >= items[item] * amount, "Please provide enough money per donnut");
         require(amount <= itemBalances[address(this)][item], "Not enough donnuts in the machine");
         itemBalances[msg.sender][item] += amount;
         itemBalances[address(this)][item] -= amount;
    }
    function getItemsByAddress(string memory itemName) public view returns(uint){
        return itemBalances[msg.sender][itemName];
    }
    function withdwarFunds() public onlyOwner{
      payable(msg.sender).transfer(address(this).balance);
    }
}