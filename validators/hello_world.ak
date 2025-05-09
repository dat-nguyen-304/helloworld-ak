use aiken/collection/list
// use aiken/crypto.{VerificationKeyHash}
// use aiken/primitive/string
use cardano/transaction.{OutputReference, Transaction, Input, Output, NoDatum}
use aiken/math
use cardano/assets.{ PolicyId, AssetName}
use cardano/address

fn is_square(n: Int) -> Bool {
    when math.sqrt(n) is {
      Some(r) -> r * r == n
      None -> False
    }
}

validator hello_world {
  spend(
    datum: Option<Int>,
    _redeemer: Data,
    _own_ref: OutputReference,
    _self: Transaction,
  ) {
    expect Some(data) = datum
    let must_not_be_negative = data >= 0
    let must_be_fibonaci = is_square(5 * data * data + 4) || is_square(5 * data * data - 4)
  
    must_not_be_negative? && must_be_fibonaci?
  }

  mint(
    _redeemer: Data, 
    _utxo: OutputReference, 
    self: Transaction
  ) {
    list.any(
      assets.flatten(self.mint),
      fn((_policy_id, _asset_name, asset_amount)) {
        asset_amount > 0
      }
    )
  }
 
}

validator treasure_chest(token_policy: PolicyId, token_name: AssetName) {
  spend(
    _datum: Option<Data>,
    _redeemer: Data,
    _own_ref: OutputReference,
    self: Transaction,
  ) {
    list.any(
      self.inputs,
      fn(Input { output: Output { value, .. }, .. }) {
        // list.any(
        //   flatten(value),
        //   fn(asset) {
        //     let (policy_id, asset_name, _asset_amount) = asset
        //     policy_id == token_policy && asset_name == token_name
        //   }
        // )
        assets.quantity_of(value, token_policy, token_name) > 0
      }
    )
  }
}

const placeholder_out_ref = OutputReference { transaction_id: "", output_index: 0 }

test hello_world_1_1() { 
  hello_world.spend(
    Some(13),
    [],
    placeholder_out_ref,
    transaction.placeholder
  )
}

test hello_world_1_2() {
  hello_world.spend(
    Some(21),
    [],
    placeholder_out_ref,
    transaction.placeholder
  )
}

test fail_hello_world_1_3() fail {
  hello_world.spend(
    Some(20),
    [],
    placeholder_out_ref,
    transaction.placeholder
  )
}

test fail_hello_world_1_4() fail {
  hello_world.spend(
    None,
    [],
    placeholder_out_ref,
    transaction.placeholder
  )
}

test hello_world_2_1() {
  let assets =
    assets.zero
      |> assets.add("pid", "tk1", 1)
      |> assets.add("bid", "tk2", -2)
  hello_world.mint(
    [],
    placeholder_out_ref,
    Transaction { ..transaction.placeholder, mint: assets }
  )
}

test fail_hello_world_2_2() fail {
  let assets =
    assets.zero
      |> assets.add("pid", "tk1", -1)
      |> assets.add("pid", "tk2", -2)
  hello_world.mint(
    [],
    placeholder_out_ref,
    Transaction { ..transaction.placeholder, mint: assets }
  )
}

const placeholder_input =
  Input {
    output_reference: placeholder_out_ref,
    output: Output {
      address: address.from_verification_key(#"00000000000000000000000000000000000000000000000000000000"),
      value: assets.zero,
      datum: NoDatum,
      reference_script: None,
    }
  }

test treasure_chest() {
  let input = Input {
    ..placeholder_input,
    output: Output {
      ..placeholder_input.output,
      value: assets.zero
      |> assets.add("pid", "boo", 2)
      |> assets.add("pid", "foo", 1)
    }
  }
    
  let tx = Transaction {
    ..transaction.placeholder,
    inputs: [input, ..transaction.placeholder.inputs],
  }
  treasure_chest.spend(
    "pid", "foo",
    None,
    [],
    placeholder_out_ref,
    tx,
  )
}

test fail_treasure_chest() fail {
  let input = Input {
    ..placeholder_input,
    output: Output {
      ..placeholder_input.output,
      value: assets.zero
      |> assets.add("pid", "boo", 2)
      |> assets.add("pid", "foo", 1)
    }
  }
    
  let tx = Transaction {
    ..transaction.placeholder,
    inputs: [input, ..transaction.placeholder.inputs],
  }
  treasure_chest.spend(
    "pid", "coo",
    None,
    [],
    placeholder_out_ref,
    tx,
  )
}