// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


// // import
// import "filename";
// import * as symbolname from "filename";
// import {symbol1 as aliass, symbol2} from "filename";


// // string
// string name = "manny";

// // integers
// uint storedata = 34;

// // boolean
// bool atrueorfalsevalue = false;

// // address
// address walletAddress = 0x72ba773893b;

// // arrays
// string[] names;

// // bytes
// bytes32 code;

// // Struct to define 
// struct User {
//     string firstName;
//     string lastName;
// }

// // enums
// enum userType {buyer, seller}

// // mappings
// mapping(address => uint) balances;


// your first contract
contract SimpleContract {
    // state variable
    uint storedData;
    
    // modifier is a conditional
    modifier onlyData() {
        require(
            storedData >= 0);
            _;
    }
    
    // function
    function set(uint x) public returns(uint) {
        storedData = x;
        return storedData;
    }
    
    function calcs(uint _a, unint _b) public pure returns (uint o_sum, uint o_product) {
        o_sum = _a + _b;
        o_product = _a * _b;
    }

    
    // event - allows logging data into the blockchain; a cheap storage means
    event Sent(address from, address to, uint storedData);
    // calling an event inside a function
    function callSent (address _to, uint data) external {
        emit Sent(msg.sender ,_to, data);
    }
    
}