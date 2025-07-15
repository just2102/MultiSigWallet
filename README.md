## Minimal Multi-Sig Wallet

This project is a minimal implementation of a multi-signature wallet built using the Foundry framework. It allows a group of owners to manage a shared wallet, requiring a specified number of confirmations before a transaction can be executed.

### Core-Logic

The `MultiSigWallet.sol` contract includes the following features:

- **Transaction Submission**: Any of the designated owners can submit a new transaction.
- **Transaction Confirmation**: Owners can confirm submitted transactions. A transaction must receive a minimum number of confirmations before it can be executed.
- **Transaction Execution**: Once a transaction has been confirmed by the required number of owners, it can be executed. This sends the specified value and data to the target address.
- **Owner Management**: The wallet is initialized with a list of owners and the required number of confirmations.

### Events

The contract emits events for key actions, allowing for easy monitoring of wallet activity:

- `TransactionSubmit`: Emitted when a new transaction is submitted.
- `TransactionConfirm`: Emitted when an owner confirms a transaction.
- `TransactionExecute`: Emitted when a transaction is executed.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy

```shell
$ forge create src/MultiSigWallet.sol:MultiSigWallet --broadcast --rpc-url <rpc-url> --private-key <your-private-key> --constructor-args <owners> <numOfConfirmations>
```

### Verify

```shell
$ forge verify-contract --chain <chain> <contractAddress> src/MultiSigWallet.sol:MultiSigWallet --verifier etherscan --etherscan-api-key <your-api-key> --constructor-args $(cast abi-encode "constructor(address[], uint8)" <owners> <numOfConfirmations>)
```
