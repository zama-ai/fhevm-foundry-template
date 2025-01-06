// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "fhevm/lib/TFHE.sol";
import {MyConfidentialERC20} from "../src/MyConfidentialERC20.sol";

contract MyConfidentialERC20MintReencryptScript is Script {
    /* @note: WARNING this example shows reencrypt DOES NOT work as expected inside a foundry script, 
    because FFI (and logs) is only called during the simulation step, NOT during the broadcasting phase
    see: https://github.com/foundry-rs/foundry/issues/5776#issuecomment-1867287499 */
    MyConfidentialERC20 public cerc20;

    function setUp() public {
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_ALICE");
        vm.startBroadcast(deployerPrivateKey);
        address AliceAdd = vm.addr(deployerPrivateKey);
        cerc20 = new MyConfidentialERC20("Naraggara", "NARA");
        cerc20.mint(AliceAdd, 1000);
        vm.stopBroadcast();
        euint64 balanceHandleAlice = cerc20.balanceOf(AliceAdd);

        //vm.sleep(30_000);
        string[] memory inputs = new string[](6);
        inputs[0] = "ts-node";
        inputs[1] = "--transpile-only";
        inputs[2] = "utils/reencrypt.ts";
        inputs[3] = vm.toString(euint64.unwrap(balanceHandleAlice));
        inputs[4] = vm.toString(bytes32(deployerPrivateKey));
        inputs[5] = vm.toString(address(cerc20));

        console.log("handle", inputs[3]);
        console.log("privKey", inputs[4]);
        console.log("contract address", inputs[5]);

        // Execute the command and get the output
        bytes memory result = vm.ffi(inputs);

        // Convert the bytes output to a string
        string memory outputStr = string(result);

        uint256 output;
        if(bytes(outputStr).length != 0){ // to handle the error in simulation mode
            output = vm.parseUint(outputStr);
        }

        console.log("Reencrypt (fake! because in simulation only) Output as uint256:", output);    
    }
}

/*contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new Counter();

        vm.stopBroadcast();
    }
}*/