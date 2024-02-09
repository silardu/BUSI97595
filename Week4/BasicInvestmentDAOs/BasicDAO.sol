pragma solidity ^0.8.0;

import "./MyNFT.sol";
import "./InvestmentContract.sol";

contract DAO {
    MyNFT public nftContract;
    InvestmentContract public investmentContract;

    struct Proposal {
        string description;
        uint yesVotes;
        uint noVotes;
        uint deadline;
        bool executed;
    }

    mapping(uint => Proposal) public proposals;
    uint public nextProposalId;

    constructor(address _nftAddress, address _investmentAddress) {
        nftContract = MyNFT(_nftAddress);
        investmentContract = InvestmentContract(_investmentAddress);
    }

    function createProposal(string memory description, uint duration) public {
        proposals[nextProposalId++] = Proposal({
            description: description,
            yesVotes: 0,
            noVotes: 0,
            deadline: block.timestamp + duration,
            executed: false
        });
    }

    function vote(uint proposalId, bool support) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.deadline, "Voting is over");
        if (support) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }

    function executeProposal(uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting not yet finished");
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;
        // Something that could be done is to define proposal types with enum, include the proposal type in Proposal struct
        // then write a logical structure depending on the proposal type here
      
    }

    function mintNFT(address to) public {
        // Could be restricted or tied to proposal outcomes
        nftContract.mint(to);
    }
}