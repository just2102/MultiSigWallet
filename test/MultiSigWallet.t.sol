// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";

contract MultiSigWalletTest is Test {
    MultiSigWallet public wallet;

    function setUp(address[] memory _owners, uint8 _numConfirmationsRequired) public {
        wallet = new MultiSigWallet(_owners, _numConfirmationsRequired);
    }
}
