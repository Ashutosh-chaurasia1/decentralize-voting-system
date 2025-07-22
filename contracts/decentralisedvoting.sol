// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    address public admin;
    uint public votingEndTime;
    bool public votingStarted;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    uint public candidateCount;

    mapping(address => bool) public hasVoted;

    constructor(uint _durationMinutes) {
        admin = msg.sender;
        votingEndTime = block.timestamp + (_durationMinutes * 1 minutes);
        votingStarted = true;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier votingOpen() {
        require(votingStarted && block.timestamp < votingEndTime, "Voting is closed");
        _;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        require(votingStarted, "Cannot add candidates after voting has ended");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
    }

    function vote(uint _candidateId) public votingOpen {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
    }

    function endVoting() public onlyAdmin {
        require(votingStarted, "Voting already ended");
        votingStarted = false;
    }

    function getWinner() public view returns (string memory winnerName, uint voteCount) {
        require(!votingStarted || block.timestamp >= votingEndTime, "Voting not yet ended");

        uint highestVotes = 0;
        uint winnerId = 0;

        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return (candidates[winnerId].name, highestVotes);
    }


//“Added one function suggested by ChatGP



    // ✅ New Function: Get all candidates with their vote counts
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory result = new Candidate[](candidateCount);
        for (uint i = 1; i <= candidateCount; i++) {
            result[i - 1] = candidates[i];
        }
        return result;
    }
}
