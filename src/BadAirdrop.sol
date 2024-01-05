// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title BadAirdrop
 * @dev A contract for performing airdrops of ERC20 tokens to multiple recipients.
 */
contract BadAirdrop {
    error InvalidLengths();
    
    address token;
    uint256 public transfers;

    constructor(address _token) {
        token = _token;
    }

    /**
     * @dev Perform a bad airdrop by transferring tokens from the sender to the contract,
     * and then transferring tokens from the contract to the specified recipients.
     * @param recipients An array of recipient addresses.
     * @param amounts An array of token amounts to be transferred to each recipient.
     */
    function airdropBad(address[] memory recipients, uint256[] memory amounts) public {
        if (recipients.length != amounts.length) revert InvalidLengths();

        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(token).transferFrom(msg.sender, address(this), amounts[i]);
        }

        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(token).transfer(recipients[i], amounts[i]);
            transfers++;
        }
    }
}