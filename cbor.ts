import { decode } from "cbor";

// Datum CBOR from your transaction
const type = process.argv[2];
let data;
if (type === "datum") {
  // data = "d8799f581c022188be106d43ef370bf9d43bf7b666a4aad646079831ab76ff18ffff";
  data =
    "d8799f581c022188be106d43ef370bf9d43bf7b666a4aad646079831ab76ff18ff420000ff";
} else data = "d8799f4f506c65617365206368617920646921ff";

const datumCbor = Buffer.from(data, "hex");
console.log({ datumCbor });

const decoded = decode(datumCbor);
// Extract the value
const publicKeyHashBuffer = decoded.value[0]; // Access the buffer
console.log({ publicKeyHashBuffer });
const publicKeyHash = publicKeyHashBuffer.toString(
  type === "datum" ? "hex" : "utf-8"
);
console.log("Public Key Hash (Hex):", publicKeyHash);

// 022188be106d43ef370bf9d43bf7b666a4aad646079831ab76ff18ff
