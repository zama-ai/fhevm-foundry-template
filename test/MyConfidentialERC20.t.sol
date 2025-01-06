// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyConfidentialERC20} from "../src/MyConfidentialERC20.sol";
import {console} from "forge-std/console.sol";

contract MyConfidentialERC20Test is Test {
    MyConfidentialERC20 public cerc20;

    function setUp() public {
        cerc20 = new MyConfidentialERC20("Naraggara", "NARA");
    }

    function test_Increment() public {
        console.log(cerc20.name());
    }
}
