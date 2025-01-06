#!/usr/bin/env node
import { createInstance } from "./instance";
import { Wallet } from "ethers";

async function reencryptHandle(
  handle: bigint,
  ethPrivateKey: string,
  contractAddress: string
) {
  try {
    const signer = new Wallet(ethPrivateKey);
    const instance = await createInstance();

    const { publicKey, privateKey } = instance.generateKeypair();
    const eip712 = instance.createEIP712(publicKey, contractAddress);

    const signature = await signer.signTypedData(
      eip712.domain,
      { Reencrypt: eip712.types.Reencrypt },
      eip712.message
    );

    const reencryptedHandle = await instance.reencrypt(
      handle,
      privateKey,
      publicKey,
      signature.replace("0x", ""),
      contractAddress,
      await signer.getAddress()
    );
    return reencryptedHandle;
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
      "Usage: ts-node fhevmjs.ts <handle> <ethPrivateKey> <contractAddress>"
    );
    process.exit(1);
  }

  const [handleStr, ethPrivateKey, contractAddress] = args;

  try {
    // Convert handle string to bigint
    const handle = BigInt(handleStr);

    // Add '0x' prefix to private key if not present
    const formattedPrivateKey = ethPrivateKey.startsWith("0x")
      ? ethPrivateKey
      : `0x${ethPrivateKey}`;

    const result = await reencryptHandle(
      handle,
      formattedPrivateKey,
      contractAddress
    );
    console.log(result.toString());
  } catch (error) {
    console.error("Error processing arguments:", error);
    process.exit(1);
  }
}

// Execute the main function
main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
