// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// A contract representing a bank acc with multiple internal accounts
contract BankAccount {
    uint totalBalance = 0;
    
    function getTotalBalance() public view returns(uint) {
        return totalBalance;
    }

    mapping(address => uint) balances;
    mapping(address => uint) depositTimes;

    // credit money into new or existing balance
    function credit() public payable {
        totalBalance += msg.value;
        uint currentBal = 0;
        if(balances[msg.sender]>0){
            currentBal = getBalance(msg.sender);
        }
        balances[msg.sender] = currentBal + msg.value;
        depositTimes[msg.sender] = block.timestamp;
    }

    // debit money from existing balances
    function debit() public payable {
        require(getBalance(msg.sender) >= msg.value, "Insufficient balance!");
        totalBalance -= msg.value;
        balances[msg.sender] -= msg.value;
        payable(msg.sender).transfer(msg.value);
    }

    function getBalance(address account) public view returns(uint) {
        uint principal = balances[account];
        uint timeElapsed = block.timestamp - depositTimes[account];

        // calculate and total the interest
        return (principal + uint((principal * 7 * timeElapsed)/ (100* 365 * 24 * 60 * 60)) + 1);
    }

    function creditToContract () public payable {
        totalBalance += msg.value;
    }
}