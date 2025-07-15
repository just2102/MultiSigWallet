// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MultiSigWallet {
    event TransactionSubmit(address indexed owner, uint256 txIndex, address to, uint256 value, bytes data);
    event TransactionConfirm(address indexed owner, uint256 txIndex, uint8 numConfirmations);
    event TransactionExecute(address indexed owner, uint256 txIndex);

    address[] public owners;
    mapping(address => bool) isOwner;
    uint8 public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint8 numConfirmations;
    }

    Transaction[] public transactions;

    // checks if an owner has confirmed a transaction with a specific txIndex
    mapping(uint256 txIndex => mapping(address owner => bool)) public isConfirmed;

    constructor(address[] memory _owners, uint8 _numConfirmationsRequired) {
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0, "Num of confirmations required");
        require(_numConfirmationsRequired <= _owners.length, "Incorrect num of confirmations");

        for (uint256 i = 0; i < _owners.length; i++) {
            address current = _owners[i];
            require(!isOwner[current], "This wallet is already an owner");

            isOwner[current] = true;
            owners.push(current);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    modifier onlyOwners() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    modifier txNotExecuted(uint256 _txIndex) {
        require(transactions[_txIndex].executed == false, "Transaction has already been executed");
        _;
    }

    modifier txNotConfirmed(uint256 _txIndex) {
        require(
            transactions[_txIndex].numConfirmations < numConfirmationsRequired, "Transaction has been confirmed already"
        );
        _;
    }

    modifier txConfirmed(uint256 _txIndex) {
        require(
            transactions[_txIndex].numConfirmations >= numConfirmationsRequired,
            "Transaction has not been confirmed by all owners"
        );
        _;
    }

    modifier ownerHasNotConfirmed(uint256 _txIndex, address _owner) {
        require(isConfirmed[_txIndex][_owner] == false, "This owner has already confirmed this TX");
        _;
    }

    function submitTransaction(address _to, uint256 _value, bytes calldata _data) public onlyOwners {
        transactions.push(Transaction({to: _to, value: _value, data: _data, executed: false, numConfirmations: 0}));
        emit TransactionSubmit(msg.sender, transactions.length - 1, _to, _value, _data);
    }

    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwners
        txExists(_txIndex)
        txNotExecuted(_txIndex)
        txNotConfirmed(_txIndex)
        ownerHasNotConfirmed(_txIndex, msg.sender)
    {
        Transaction memory transaction = transactions[_txIndex];
        transaction.numConfirmations++;
        isConfirmed[_txIndex][msg.sender] = true;

        emit TransactionConfirm(msg.sender, _txIndex, transaction.numConfirmations);
    }

    function executeTransaction(uint256 _txIndex) public onlyOwners txExists(_txIndex) txConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        transaction.executed = true;

        (bool success,) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Failed to execute transaction");

        emit TransactionExecute(msg.sender, _txIndex);
    }
}
