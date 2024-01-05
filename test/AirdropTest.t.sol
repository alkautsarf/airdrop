// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {GoodAirdrop} from "../src/GoodAirdrop.sol";
import {BadAirdrop} from "../src/BadAirdrop.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract AirdropTest is Test {
    GoodAirdrop public goodAirdrop;
    BadAirdrop public badAirdrop;
    ERC20Mock public token;

    uint256 public constant TOTAL_SUPPLY = 1000 ether;
    uint256 public constant AIRDROP_AMOUNT = 1 ether;
    address public OWNER = makeAddr("owner");

    address[] public recipients;
    uint256[] public amounts;
    uint256 public totalAmount;

    function setUp() public {
        token = new ERC20Mock();
        token.mint(address(this), TOTAL_SUPPLY);
        goodAirdrop = new GoodAirdrop(address(token));
        badAirdrop = new BadAirdrop(address(token));

        for (uint256 i = 1; i <= 10;) {
            recipients.push(address(uint160(i)));
            amounts.push(AIRDROP_AMOUNT);
            unchecked {
                i++;
                totalAmount += AIRDROP_AMOUNT;
            }
        }
    }

    function testMint() public {
        assertEq(token.balanceOf(address(this)), TOTAL_SUPPLY);
    }

    function testRevertsInvalidLengthsBadAirdrop() public {
        uint256[] memory m_amounts = new uint256[](1);
        m_amounts[0] = 1 ether;
        vm.expectRevert(BadAirdrop.InvalidLengths.selector);
        badAirdrop.airdropBad(recipients, m_amounts);
    }
    
    function testRevertsInvalidLengthsGoodAirdrop() public {
        uint256[] memory m_amounts = new uint256[](1);
        m_amounts[0] = 1 ether;
        vm.expectRevert(BadAirdrop.InvalidLengths.selector);
        goodAirdrop.airdropGood(recipients, m_amounts, 1 ether);
    }

    function testAirdropBad() public {
        token.approve(address(badAirdrop), TOTAL_SUPPLY);
        badAirdrop.airdropBad(recipients, amounts);
        assertEq(token.balanceOf(address(this)), TOTAL_SUPPLY - totalAmount);

        for(uint256 i = 0; i < recipients.length;) {
            assertEq(token.balanceOf(recipients[i]), AIRDROP_AMOUNT);
            unchecked {
                i++;
            }
        }
    }

    function testAirdropGood() public {
        token.approve(address(goodAirdrop), TOTAL_SUPPLY);
        goodAirdrop.airdropGood(recipients, amounts, totalAmount);
        assertEq(token.balanceOf(address(this)), TOTAL_SUPPLY - totalAmount);

        for(uint256 i = 0; i < recipients.length;) {
            assertEq(token.balanceOf(recipients[i]), AIRDROP_AMOUNT);
            unchecked {
                i++;
            }
        }
    }
}