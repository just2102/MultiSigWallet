// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";

contract MultiSigWalletTest is Test {
    MultiSigWallet public wallet;
    address owner1 = makeAddr("owner1");
    address owner2 = makeAddr("owner2");
    address owner3 = makeAddr("owner3");

    function setUp() public {
        address[] memory owners = new address[](3);
        owners[0] = owner1;
        owners[1] = owner2;
        owners[2] = owner3;
        wallet = new MultiSigWallet(owners, 2);
    }

    function test_SubmitTransactionRevertWhen_NotAnOwner() public {
        vm.expectRevert("Not an owner");
        wallet.submitTransaction(address(this), 1 wei, bytes(""));
    }

    function test_SubmitTransaction() public {
        vm.startPrank(owner1);
        wallet.submitTransaction(address(this), 1 wei, bytes(""));
        vm.stopPrank();
    }
}
