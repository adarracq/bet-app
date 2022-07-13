// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract MyAppName {

    address owner;

    uint public test;

    struct Wallet {
        uint balance;
    }

    mapping(address => Wallet) Wallets;

    constructor() public {
        owner = msg.sender;
        test = 3;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function getTotalBalance() public view isOwner returns (uint)  {
        return address(this).balance;
    }

    function getBalance() public view returns (uint) {
        return Wallets[msg.sender].balance;
    }

    function withdraw(address payable to, uint amount) public {
        require(Wallets[msg.sender].balance >= amount, "Amount insufficient");
        Wallets[msg.sender].balance -= amount;
        to.transfer(amount);
    }

    function bet(uint amount) public {
        require(Wallets[msg.sender].balance >= amount, "Oversized amount");
        Wallets[msg.sender].balance -= amount;
    }

    function getReward(uint amount) public  {
        Wallets[msg.sender].balance += amount;
    }

    /*
    function distribute(address[] memory winners, uint amount) public isOwner {
        for(uint i = 0; i < winners.length; i++) {
            Wallets[winners[i]].balance += amount;
        }
    }*/

    function send() external payable {
        Wallets[msg.sender].balance += msg.value;
    }
}