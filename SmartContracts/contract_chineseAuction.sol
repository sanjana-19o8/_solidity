// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

// This contract implements the problem of Chinese auction or penny social
contract Auction {
    struct Item{
        uint itemId;
        uint[] tokens;
    }
    struct Bidder {
        address bidder;
        uint bidderId;
        uint balance;
    }

    mapping(address => Bidder) tokenDetails;
    Bidder[4] bidders;
    Item[3] items;

    address public beneficiary;
    address[3] public finalBidders;

    uint bidderCount = 1;
    bool ended = false;

    event FinalBid(uint ItemId, address Address);

    constructor() {
        beneficiary = msg.sender;
        uint[] memory emptyArr;
        for(uint i=0; i<3; i++){
            items[i] = Item({
                itemId: i+1,
                tokens: emptyArr
            });
        }
    }

    modifier isActive(){
        require(!ended, 'Auction Ended');
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == beneficiary, 'Only beneficiary can call the final bids');
        _;
    }

    function register() isActive public payable {
        if(tokenDetails[msg.sender].bidderId > 0){
            revert('Already registered. Proceed to bid');
        }
        bidders[bidderCount] = Bidder({
            bidder: msg.sender,
            bidderId: bidderCount,
            balance: 5
        });
        tokenDetails[msg.sender] = bidders[bidderCount];
        bidderCount++;
    }

    function bid(uint _item, uint _amount) isActive public payable {
        require(_amount <= tokenDetails[msg.sender].balance, 'Insufficient token balance');
        require(_item < 3, 'Invalid item ID');

        tokenDetails[msg.sender].balance -= _amount;
        bidders[tokenDetails[msg.sender].bidderId].balance = tokenDetails[msg.sender].balance; 
        
        Item storage bidItem = items[_item];
        
        for(uint i=0 ; i< _amount; i++){
            bidItem.tokens.push(tokenDetails[msg.sender].bidderId);
        }
    }

    function showFinalBids() onlyOwner public {
        uint count =0 ;
        for(uint i=0; i<3; i++){
            Item storage curr = items[i];
            if(curr.tokens.length != 0){
                uint randomId = (block.number / curr.tokens.length) % curr.tokens.length;
                uint winnerId = curr.tokens[randomId];
                finalBidders[i] = bidders[winnerId].bidder;
                emit FinalBid(i, finalBidders[i]);
            } else {
                count ++;
            }
        }

        if(count==0){
            ended = true;
        }
    }

    function getBidder(uint _id) public view returns(address, uint, uint) {
        return (bidders[_id].bidder, bidders[_id].bidderId , bidders[_id].balance);
    }
}