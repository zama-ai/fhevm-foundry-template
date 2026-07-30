# FHEVM Foundry Template

A Foundry-based template for developing Fully Homomorphic Encryption (FHE) enabled Solidity smart contracts using the
FHEVM protocol by Zama.

## Quick Start

### Prerequisites

- **Foundry**: [Installation guide](https://book.getfoundry.sh/getting-started/installation)

### Installation

1. **Install dependencies**

   ```bash
   forge soldeer install
   ```

2. **Compile and test**

   ```bash
   forge build
   forge test -vvv
   ```

3. **Deploy to local network**

   Start an Anvil node (a `hardhat node` works too), then stand the FHEVM host stack up on it —
   straight from this project; the deployment logic lives in
   [`@fhevm/host-contracts-cleartext`](../sdk/host-contracts-cleartext), the package that owns FHEVM
   deployment for every target:

   ```bash
   anvil

   # In another terminal — no --broadcast and no key; the node's cheat codes do the placement:
   forge script script/DeployFhevmStack.s.sol --rpc-url http://localhost:8545
   ```

   Then deploy your contracts to it (the private key below is Anvil's funded account #0):

   ```bash
   forge script script/DeployFHECounter.s.sol --rpc-url http://localhost:8545 \
       --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
   ```

---

> [!WARNING]
> 🚧 **Tests and scripts run only against the local FHEVM mock — never against Sepolia or any live FHEVM deployment.**
>
> `forge test` (and any script that depends on FHE decryption) relies on `forge-fhevm`'s in-memory mock of the FHEVM host contracts — mock KMS / input signers, plaintext database. Those mocks do not exist on a live network, so pointing tests or test-style scripts at Sepolia will fail:
>
> ```bash
> # ❌ FAIL — no mock host contracts on Sepolia
> forge test --rpc-url http://sepolia --broadcast
>
> # ❌ FAIL — encrypted state on a live network can't be decrypted in-process
> forge script script/SomeFHEScript.s.sol --rpc-url http://sepolia --broadcast
> ```
>
> To interact with a contract on Sepolia, deploy it (step 4 below) and interact through the [Zama SDK](https://github.com/zama-ai/sdk) from your dApp.

4. **Deploy to Sepolia Testnet**

   ```bash
   cp .env.example .env
   # Edit .env with your deployer key and RPC URL

   source .env
   forge script script/DeployFHECounter.s.sol \
       --rpc-url $RPC_URL \
       --private-key $DEPLOYER_PRIVATE_KEY \
       --broadcast --verify
   ```

## Project Structure

```
fhevm-foundry-template/
├── src/                 # Smart contract source files
│   └── FHECounter.sol   # Example FHE counter contract
├── test/                # Test files
│   └── FHECounter.t.sol # Tests using forge-fhevm
├── script/              # Deployment scripts
│   └── DeployFHECounter.s.sol
├── foundry.toml         # Foundry configuration
└── remappings.txt       # Dependency remappings
```

## Available Scripts

| Script                                     | Description              |
| ------------------------------------------ | ------------------------ |
| `forge build`                              | Compile all contracts    |
| `forge test -vvv`                          | Run all tests            |
| `forge test --match-test test_name -vvv`   | Run a single test        |
| `forge fmt`                                | Format code              |
| `forge fmt --check`                        | Check formatting         |

## Documentation

- [FHEVM Documentation](https://docs.zama.org/fhevm)
- [FHEVM Quick Start Tutorial](https://docs.zama.org/protocol/solidity-guides/getting-started/quick-start-tutorial)
- [forge-fhevm](../sdk/forge-fhevm) — the Foundry testing library this template uses

## License

This project is licensed under the BSD-3-Clause-Clear License. See the [LICENSE](LICENSE) file for details.

## Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/zama-ai/fhevm/issues)
- **Documentation**: [FHEVM Docs](https://docs.zama.org)
- **Community**: [Zama Discord](https://discord.gg/zama)
