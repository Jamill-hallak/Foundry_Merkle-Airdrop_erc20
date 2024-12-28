// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";


contract MerkleAirdrop is EIP712{
    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                               States
    //////////////////////////////////////////////////////////////*/
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address => bool) private s_hasClaimed;
    bytes32 private constant MESSAGE_TYPEHASH =
    keccak256("AirdropClaim(address account,uint256 amount)");
    /*//////////////////////////////////////////////////////////////
                               Errors
    //////////////////////////////////////////////////////////////*/

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error  MerkleAirdrop__InvalidSignature();
    /*//////////////////////////////////////////////////////////////
                               Events
    //////////////////////////////////////////////////////////////*/

    event Claimed(address account, uint256 amount);
    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("Merkle Airdrop", "1.0.0"){
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, 
    bytes32[] calldata merkleProof,uint8 v,bytes32 r,bytes32 s) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        if(!_isValidSignature(account,getMessageHash(account, amount), v, r, s)){
         revert MerkleAirdrop__InvalidSignature();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claimed(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    /*//////////////////////////////////////////////////////////////
                             VIEW AND PURE
    //////////////////////////////////////////////////////////////*/
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
    function getMessageHash(address account, uint256 amount) public view returns(bytes32){
     return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, account,amount ))
        );
    }
    function _isValidSignature(address account,bytes32 digest, uint8 v, bytes32 r, bytes32 s) 
    internal pure returns(bool){
 
            (address actualSigner,
            /*ECDSA.RecoverError recoverError*/,
            /*bytes32 signatureLength*/) = ECDSA.tryRecover(digest, v, r, s);
        return (actualSigner == account);
    }
}
