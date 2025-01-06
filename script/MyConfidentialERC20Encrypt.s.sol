// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "fhevm/lib/TFHE.sol";
import {MyConfidentialERC20} from "../src/MyConfidentialERC20.sol";

contract MyConfidentialERC20MintEncryptScript is Script {
    /* @note: this example shows user input encryption WORKING as expected inside a foundry script, 
    because for encryption, contrarily to reencryption/decryption, data does NOT depend on the onchain Sepolia state */
    MyConfidentialERC20 public cerc20;

    function setUp() public {
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_ALICE");
        vm.startBroadcast(deployerPrivateKey);
        cerc20 = new MyConfidentialERC20("Naraggara", "NARA");
        address AliceAdd = vm.addr(deployerPrivateKey);
        address BobAdd = vm.addr(vm.envUint("PRIVATE_KEY_BOB"));
        cerc20.mint(AliceAdd, 1000);

        string[] memory inputs = new string[](6);
        inputs[0] = "ts-node";
        inputs[1] = "--transpile-only";
        inputs[2] = "utils/encrypt.ts";
        inputs[3] = "42";
        inputs[4] = vm.toString(bytes32(deployerPrivateKey));
        inputs[5] = vm.toString(address(cerc20));

        // Execute the command and get the output
        bytes memory result = vm.ffi(inputs);

        // Convert the bytes output to a string
        string memory outputStr = string(result);
        console.log("outputStr",outputStr);
        console.log("Encrypted transfer Amount:", substring(outputStr,0,66));    
        console.log("Encrypted inputProof:", substring(outputStr,67,bytes(outputStr).length));
        einput encAmount = einput.wrap(vm.parseBytes32(substring(outputStr,0,66)));
        console.log(bytes(outputStr).length);
        bytes memory inputProof = vm.parseBytes(substring(outputStr,67,bytes(outputStr).length));
        cerc20.transfer(BobAdd, encAmount, inputProof);

        uint256 balanceHandleAlice = euint64.unwrap(cerc20.balanceOf(AliceAdd));
        uint256 balanceHandleBob = euint64.unwrap(cerc20.balanceOf(BobAdd));

        console.log("Alice's handle after transfer", balanceHandleAlice);
        console.log("Alice's privKey", vm.toString(bytes32(deployerPrivateKey)));
        console.log("Bob's handle after transfer", balanceHandleBob);
        console.log("Bob's privKey", vm.toString(bytes32(vm.envUint("PRIVATE_KEY_BOB"))));
        console.log("contract address", address(cerc20));

        vm.stopBroadcast();
    }
}

function substring(string memory str, uint startIndex, uint endIndex) pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex - startIndex);
    for (uint i = startIndex; i < endIndex; i++) {
        result[i - startIndex] = strBytes[i];
    }
    return string(result);
}