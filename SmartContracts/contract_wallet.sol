// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// A basic Ether wallet 
// to send and receive ether
// only owner can be able to send ether


contract EtherWallet {
    address payable public owner ;
    constructor () {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint _amount) external {
         require(msg.sender == owner, "Caller is not Owner!");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}