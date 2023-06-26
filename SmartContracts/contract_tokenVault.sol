// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);
}

contract MyTokenVault {
    address public owner;
    IERC20 public myToken;
    uint256 public tokenRewardRate;
    uint256 public tokenRewardDuration;

    struct Deposit {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Deposit) public deposits;

    event DepositEther(address indexed depositer, uint256 amount);
    event WithdrawEther(address indexed withdrawer, uint256 amount);
    event ClaimTokens(address indexed claimant, uint256 amount);
    
    constructor(address _myTokenAddress) {
        owner = msg.sender;
        myToken = IERC20(_myTokenAddress);
        tokenRewardRate = 1;
        tokenRewardDuration = 1;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only owner can access this method.");
        _;
    }

    function calculateTokenReward(address acc) public view returns(uint256) {
        Deposit storage deposit = deposits[acc];
        if(deposit.amount > 0) {
            uint256 elapsedTime = block.timestamp - deposit.timestamp;
            uint256 reward = deposit.amount * tokenRewardRate * elapsedTime / tokenRewardDuration / 1 ether;
            return reward;
        } else {
            return 0;
        }
    }

    function depositEther() external payable {
        require(msg.value > 0, "No Ether to deposit.");
        uint256 amount = msg.value;
        if(deposits[msg.sender].amount == 0){
            deposits[msg.sender].timestamp = block.timestamp;
        } else {
            uint256 reward = calculateTokenReward(msg.sender);
            if(reward>0){
                myToken.transfer(msg.sender, reward);
                emit ClaimTokens(msg.sender, reward);
            }
        }
        deposits[msg.sender].amount += amount;
    }

    function withdrawEther(uint256 amount) external payable {
        require(amount > 0, "Withdraw amount must be greater than 0.");
        require(amount <= deposits[msg.sender].amount, "Insufficient balance in vault.");

        deposits[msg.sender].amount -= amount;
        payable(msg.sender).transfer(amount);
        emit WithdrawEther(msg.sender, amount);
    }

    function claimTokens() external {
        uint256 reward = calculateTokenReward(msg.sender);
        require(reward>0, "No tokens to be claimed." );

        deposits[msg.sender].timestamp = block.timestamp;
        myToken.transfer(msg.sender, reward);

        emit ClaimTokens(msg.sender, reward);
    }
}