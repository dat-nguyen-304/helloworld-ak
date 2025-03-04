// use cardano/assets.{AssetName, PolicyId}
// use aiken/collection/list
// use cardano/transaction.{Input, Output, OutputReference}
// use cardano/address.{Address, Credential, PaymentCredential}
// use cardano/assets.{Value}
// use aiken/collection/pairs
// use aiken/crypto.{
//   Blake2b_224, Hash, Script, ScriptHash, VerificationKey, VerificationKeyHash
// }

// fn exact(
//   flat: List<(PolicyId, AssetName, Int)>,
//   pid: PolicyId,
//   tkn: AssetName,
//   amt: Int,
// ) -> Bool {
//  list.any(flat,  fn(t) -> Bool {
//    pid == t.1st && tkn == t.2nd && amt == t.3rd
//  })
// }

// fn input_by_ref(
//   inputs: List<Input>,
//   output_reference: OutputReference,
// ) -> Input {
//   expect Some(inp) = inputs
//     |> list.find(fn(input) { input.output_reference == output_reference })
//   inp
// }

// fn at_least(
//   payout_address: Address,
//   payout_value: Value,
//   outputs: List<Output>,
// ) -> Bool {
//     list.any(outputs, fn(output) { 
//       output.address == payout_address 
//     })
// }

// type PublicKeyHash =
//   Hash<Blake2b_224, VerificationKey>

// pub fn from_verification_key(vk: PublicKeyHash) -> Address {
//   Address { payment_credential: PaymentCredential(vk), stake_credential: None }
// }
