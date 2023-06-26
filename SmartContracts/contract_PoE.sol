// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// A Proof of Existence contract
contract ProofOfExistence {
    mapping(bytes32 => bool) private proofs;

    // store a proof in the contract state
    function storeProof(bytes32 proof) public {
        proofs[proof] = true;
    }

    // calculate and store proof for a doc
    function notarize(string memory _doc) public {
        bytes32 proof = proofFor(_doc);
        storeProof(proof);
    }

    // check if a document has been notarized
    function proofFor(string memory _doc) internal pure returns (bytes32) {
        return sha256(bytes(_doc));
    }

    function checkDocument(string memory _doc) public view returns (bool) {
        bytes32 proof = proofFor(_doc);
        return proofs[proof];
    }
}
