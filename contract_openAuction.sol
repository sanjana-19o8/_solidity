// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// The contract implements a simple auction where everyone can send their bids during a bidding period. 
// The bids already include sending money(or Ether) which is returned if a higher bid is raised. On completion of bidding period, the beneficiary can receive their money.
contract OpenAuction {
    address payable public beneficiary;
    uint public auctionEndTime;
    // to store current state
    address highestBidder;
    uint public highestBid;
    // prev bids
    mapping(address => uint) pendingReturns;
    bool ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address finalBidder, uint amount);

    // possible error for request failures
    error AuctionAlreadyEnded();
    error BidNotHighEnough();
    error AuctionNotYetEnded();
    error AuctionEndAlreadyCalled();

    constructor(uint biddingTime, address payable _beneficiary){
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + biddingTime;
    }

    function bid() external payable{
        if(block.timestamp < auctionEndTime){
            revert AuctionAlreadyEnded();
        }
        if(msg.value <= highestBid){
            revert BidNotHighEnough();
        }
        // update new bid as highest bid
        if(highestBid!= 0){
            // allowing bidders to withraw their bid amount themselves
            // alternative: use highestBidder.send(highestBid)
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() external returns(bool){
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "There is no balance amount to return");
        if(payable(msg.sender).send(amount)){
            pendingReturns[msg.sender] = 0;
            return true;
        } else {
            return false;
        }
    }

    function auctionEnd() external {
        if(block.timestamp < auctionEndTime){
            revert AuctionNotYetEnded();
        }
        if(ended){
            revert AuctionEndAlreadyCalled();
        }
        // end Auction
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        // transfer final bid amount to beneficiary
        beneficiary.transfer(highestBid);
    }
}