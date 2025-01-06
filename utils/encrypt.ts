#!/usr/bin/env node
import { createInstance } from "./instance";
import { Wallet } from "ethers";

async function encryptAmount(
  amount: bigint,
  ethPrivateKey: string,
  contractAddress: string
) {
  try {
    const signer = new Wallet(ethPrivateKey);
    const instance = await createInstance();
    const input = instance.createEncryptedInput(
      contractAddress,
      signer.address
    );
    input.add64(amount);
    const encryptedAmount = await silentRun(() => input.encrypt());
    return encryptedAmount;
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

async function main() {
  // Get command line arguments
  const args = process.argv.slice(2);

  if (args.length !== 3) {
    console.error(
      "Usage: ts-node fhevmjs.ts <amount> <ethPrivateKey> <contractAddress>"
    );
    process.exit(1);
  }

  const [amountStr, ethPrivateKey, contractAddress] = args;

  try {
    // Convert handle string to bigint
    const amount = BigInt(amountStr);

    // Add '0x' prefix to private key if not present
    const formattedPrivateKey = ethPrivateKey.startsWith("0x")
      ? ethPrivateKey
      : `0x${ethPrivateKey}`;

    const encryptedAmount = await encryptAmount(
      amount,
      formattedPrivateKey,
      contractAddress
    );
    console.log(
      uint8ArrayToHex(encryptedAmount.handles[0]),
      uint8ArrayToHex(encryptedAmount.inputProof)
    );
  } catch (error) {
    console.error("Error processing arguments:", error);
    process.exit(1);
  }
}

async function silentRun(fn) {
  const originalLog = console.log;
  console.log = () => {};

  try {
    const result = await fn();
    console.log = originalLog;
    return result;
  } catch (error) {
    console.log = originalLog;
    throw error;
  }
}

function uint8ArrayToHex(uint8Array) {
  return (
    "0x" +
    Array.from(uint8Array)
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("")
  );
}

// Execute the main function
main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
