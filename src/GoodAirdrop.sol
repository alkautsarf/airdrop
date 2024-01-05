// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GoodAirdrop {
    error InvalidLengths();
    
    address public immutable i_token;
    uint256 public transfers;

    constructor(address _token) {
        i_token = _token;
    }

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