import { bech32 } from "bech32";
import { blake2b } from "blakejs";

// Function to decode Bech32-encoded public key and hash it
function computePaymentKeyHash(bech32Key: string): string {
  // Decode the Bech32-encoded public key
  const decoded = bech32.decode(bech32Key);
  const rawBytes = new Uint8Array(bech32.fromWords(decoded.words));

  console.log("Raw Public Key Bytes:", Buffer.from(rawBytes).toString("hex"));

  // Compute Blake2b-224 hash
  const hash = blake2b(rawBytes, undefined, 28); // 28 bytes for Blake2b-224
  return Buffer.from(hash).toString("hex");
}

// Example input (your public key)
const publicKey =
  "ed25519_pk1cr4j0et862dlw6d05fwaqsnhqu488u59zhfhemwqdkeweve5c9qsp5kqex";
const paymentKeyHash = computePaymentKeyHash(publicKey);

console.log("Payment Key Hash:", paymentKeyHash);
