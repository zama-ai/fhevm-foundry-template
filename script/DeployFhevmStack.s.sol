// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {DeployFhevmStackLocal} from "@fhevm/host-contracts-cleartext/deploy/DeployFhevmStackLocal.s.sol";

/// @notice Stands the FHEVM cleartext host stack up on a running local node (anvil or `hardhat node`):
///
///     forge script script/DeployFhevmStack.s.sol --rpc-url http://localhost:8545
///
/// No `--broadcast`, no key: the node's cheat codes do the placement, and the deployment logic lives in
/// the host-contracts-cleartext package — the package that owns FHEVM deployment for every target.
contract DeployFhevmStack is DeployFhevmStackLocal {}
