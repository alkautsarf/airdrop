// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GoodAirdrop {
    error InvalidLengths();
    
    address public immutable i_token;
    uint256 public transfers;

    /**
     * @dev Initializes the GoodAirdrop contract.
     * @param _token The address of the ERC20 token to be used for airdrop.
     */
    constructor(address _token) {
        i_token = _token;
    }

    /**
     * @dev Performs airdrop of tokens to multiple recipients.
     * @param recipients The array of recipient addresses.
     * @param amounts The array of token amounts to be transferred to each recipient.
     * @param totalAmount The total amount of tokens to be transferred from the sender's address.
     */
    function airdropGood(address[] calldata recipients, uint256[] calldata amounts, uint256 totalAmount) public {
        if (recipients.length != amounts.length) revert InvalidLengths();
        IERC20(i_token).transferFrom(msg.sender, address(this), totalAmount);
        for (uint256 i = 0; i < recipients.length;) {
            IERC20(i_token).transfer(recipients[i], amounts[i]);
            unchecked {
                i++;
            }
        }
        unchecked {
            transfers += recipients.length;
        }
    }
}