// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/GuardHook.sol";

contract DeployGuardHook is Script {
    
    // Replace with actual USDC address on Arc Testnet
    address constant ARC_TESTNET_USDC = 0x036CbD53842c5426634e7929541eC2318f3dCF7e; 
    // Note: Confirm the official USDC address on Arc testnet before deploying

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        GuardHook guard = new GuardHook(ARC_TESTNET_USDC);

        vm.stopBroadcast();

        console.log("GuardHook deployed at:", address(guard));
    }
}
