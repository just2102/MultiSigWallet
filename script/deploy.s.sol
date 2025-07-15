// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";

contract MultiSigWalletScript is Script {
    MultiSigWallet public wallet;

    function setUp() public {}

    function run(address[] memory owners, uint8 numOfConfirmations) public {
        vm.startBroadcast();

        wallet = new MultiSigWallet(owners, numOfConfirmations);

        vm.stopBroadcast();
    }
}
