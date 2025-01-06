import { createInstance as createFhevmInstance } from "fhevmjs";
import { FhevmInstance } from "fhevmjs/node";
import * as dotenv from "dotenv";

import { ACL_ADDRESS, GATEWAY_URL, KMSVERIFIER_ADDRESS } from "./constants";

dotenv.config();

const kmsAdd = KMSVERIFIER_ADDRESS;
const aclAdd = ACL_ADDRESS;

export const createInstance = async (): Promise<FhevmInstance> => {
  const instance = await createFhevmInstance({
    kmsContractAddress: kmsAdd,
    aclContractAddress: aclAdd,
    networkUrl: process.env.SEPOLIA_RPC_URL,
    gatewayUrl: GATEWAY_URL,
  });
  return instance;
};
