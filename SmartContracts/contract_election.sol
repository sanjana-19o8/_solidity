// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// This contract represents an Election ballot

contract Election {
    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidateCount = 0;

    event votedEvent(uint indexed _candidateId);

    function addCandidate(string memory _name) private {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

    function callElection() public{
        addCandidate('Logan');
        addCandidate('Anna');
        addCandidate('Mayor');
    }

    function vote(uint _candidateId) public{
        require(!voters[msg.sender]);
        require(_candidateId > 0 && _candidateId <= candidateCount);

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }
}