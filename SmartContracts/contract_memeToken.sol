// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

abstract contract PDTToken is ERC20, ERC20Burnable, Ownable {
    uint256 private constant _decimals = 18;
    uint256 private constant _initialSupply = 1e12 * 10**_decimals;

    // Addresses for token allocations
    address private constant _liquidityAddress = 0xaCa317851021f1042E3B57F0C55203e28097b6ae; // Address for liquidity provision
    address private constant _developmentAddress = 0xaCa317851021f1042E3B57F0C55203e28097b6ae; // Address for development team and project funding
    address private constant _communityAddress = 0xaCa317851021f1042E3B57F0C55203e28097b6ae; // Address for community rewards
    address private constant _marketingAddress = 0xaCa317851021f1042E3B57F0C55203e28097b6ae; // Address for marketing and partnerships
    address private constant _reserveAddress = 0xaCa317851021f1042E3B57F0C55203e28097b6ae; // Address for reserve fund

    // Token allocation percentages (divided by 1000)
    uint256 private constant _liquidityAllocation = 500; // 50%
    uint256 private constant _developmentAllocation = 200; // 20%
    uint256 private constant _communityAllocation = 100; // 10%
    uint256 private constant _marketingAllocation = 100; // 10%
    uint256 private constant _reserveAllocation = 100; // 10%

    // Anti-whale measures
    uint256 private constant _maxTransactionAmount = 1e10 * 10**_decimals; // Maximum transaction amount (10% of total supply)
    uint256 private constant _maxTokenPerAccount = 1e11 * 10**_decimals; // Maximum token holding per account (10% of total supply)

    constructor() ERC20("Hybrid Meme Token", "HMT") {
        _mint(address(this), _initialSupply);

        // Distribute tokens to specified addresses
        uint256 allocationAmount = _initialSupply;

        uint256 liquidityAmount = (allocationAmount * _liquidityAllocation) / 1000;
        allocationAmount -= liquidityAmount;
        _transfer(address(this), _liquidityAddress, liquidityAmount);

        uint256 developmentAmount = (allocationAmount * _developmentAllocation) / 1000;
        allocationAmount -= developmentAmount;
        _transfer(address(this), _developmentAddress, developmentAmount);

        uint256 communityAmount = (allocationAmount * _communityAllocation) / 1000;
        allocationAmount -= communityAmount;
        _transfer(address(this), _communityAddress, communityAmount);

        uint256 marketingAmount = (allocationAmount * _marketingAllocation) / 1000;
        allocationAmount -= marketingAmount;
        _transfer(address(this), _marketingAddress, marketingAmount);

        uint256 reserveAmount = (allocationAmount * _reserveAllocation) / 1000;
        allocationAmount -= reserveAmount;
        _transfer(address(this), _reserveAddress, reserveAmount);

        // Burn remaining tokens
        _burn(address(this), allocationAmount);
    }

    function _transferInternal (
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(amount <= _maxTransactionAmount, "Transfer amount exceeds maximum allowed");
        require(balanceOf(recipient) + amount <= _maxTokenPerAccount, "Recipient balance would exceed maximum allowed");

        super._transfer(sender, recipient, amount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Ownership cannot be renounced for this contract");
    }
}