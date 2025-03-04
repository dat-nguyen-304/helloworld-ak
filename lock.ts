import { Asset, deserializeAddress, mConStr0 } from "@meshsdk/core";
import { getScript, getTxBuilder, wallet } from "./common";

async function main() {
  // these are the assets we want to lock into the contract
  const assets: Asset[] = [
    {
      unit: "lovelace",
      quantity: "1000000",
    },
  ];

  // get utxo and wallet address
  const utxos = await wallet.getUtxos();
  const walletAddress = (await wallet.getUsedAddresses())[0];
  console.log({ walletAddress });

  const { scriptAddr, scriptCbor } = getScript();
  console.log({ scriptAddr, scriptCbor });

  // hash of the public key of the wallet, to be used in the datum
  const signerHash = deserializeAddress(walletAddress).pubKeyHash;
  console.log({ signerHash });

  const buffer = Buffer.from([0x00, 0x00]); // Binary data with hex "0000"
  const string = buffer.toString("utf-8"); // "0000"

  // build transaction with MeshTxBuilder
  const txBuilder = getTxBuilder();
  await txBuilder
    .txOut(scriptAddr, assets) // send assets to the script address
    .txOutDatumHashValue(mConStr0([100])) // provide the datum where `"constructor": 0`
    .changeAddress(walletAddress) // send change back to the wallet address
    .selectUtxosFrom(utxos)
    .complete();
  const unsignedTx = txBuilder.txHex;
  console.log({ unsignedTx });

  const signedTx = await wallet.signTx(unsignedTx);
  console.log({ signedTx });

  const txHash = await wallet.submitTx(signedTx);
  console.log(`1 tADA locked into the contract at Tx ID: ${txHash}`);
}

main();
