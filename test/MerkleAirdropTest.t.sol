// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {BagelToken} from "../../src/BagelToken.sol";
import {Test,console} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "../../script/DeployMerkleAirdrop.s.sol";
contract MerkleAirdropTest is  ZkSyncChainChecker,Test {

    MerkleAirdrop public airdrop;
    BagelToken public token ;
    uint256 amountToCollect = (25 * 1e18); // 25.000000
    uint256 amountToSend = amountToCollect * 4;
    bytes32 [] proof =[bytes32(0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a),
    bytes32(0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576)];
    bytes32 root =0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user ;
    address gasPayer ;
    uint256 privatekey ;
    uint256 gasPayerPrivateKey ;

function setUp()public{
    if(!isZkSyncChain()){
        DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
        (airdrop, token) = deployer.deployMerkleAirdrop();

    } 
    else{
    token = new BagelToken();
    airdrop= new MerkleAirdrop(root,token);
    token.mint(address(airdrop),amountToSend);
    }
    (user,privatekey)=makeAddrAndKey("user");
    (gasPayer,gasPayerPrivateKey)=makeAddrAndKey("payer");

}

function testUserCanClaim()public{
    bytes32 digest = airdrop.getMessageHash(user,amountToCollect);
     (uint8 v, bytes32 r, bytes32 s) = vm.sign(privatekey, digest);
    
    vm.prank(gasPayer);
    airdrop.claim(user,amountToCollect,proof,v,r,s);
    vm.stopPrank();
    assert(token.balanceOf(user)==amountToCollect);
} 




}