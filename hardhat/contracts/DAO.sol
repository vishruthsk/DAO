//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
interface iNFTmarketplace{
    function purchace(uint256 _tokenid) public payable;
    function getprice() external view returns(uint256);
    function available(uint256 _tokenid) external view returns(bool);
}
interface iNFT{
    function balanceOf(address owner)external view returns(uint256);
    function tokenOfOwnerByIndex(address owner,uint256 index) external view returns(int256);

}
//create proposal
//vote on a proposal
//execute a proposal
contract DAO is Ownable{
    iNFTmarketplace nftmarketplace;
    iNFT nft;
    enum vote{
        yes,
        no

    }
    struct Proposal{
        //nft to buy 
        uint256 nfttokenid;
        //deadline
        uint256 deadline;
        //number of votes
        uint256 yes_votes;
        uint256 no_votes;
        bool executed;
        //tokenids voted 
        mapping(uint256 => bool) voters;
    }
    //proposalid to proposal
    mapping(uint256 => Proposal) public proposals;
    uint256 public numproposal;
    constructor(uint256 _nftmarketplace, uint256 _nft) payable{
        nftmarketplace=iNFTmarketplace[_nftmarketplace];
        nft=iNFT[_nft];
    }
    modifier memberonly(){
        require(iNFT.balanceOf(msg.sender)>0,"not a dao member");
        _;
    }
    modifier activeproposal(uint256 proposalid) {
        require(proposals[proosalid].deadline > block.timestamp,"proposal inactive");
        _; 
    }
    modifier inactiveproposal(uint256 proposalid){
        require( proposals[proposalid].deadline <= block.timestamp,"proposal active" );
        require(proposals[proposalid].executed==false,"proposal already executed");
        _;
    }
//returns proposal id 
    function createproposal(uint256 _nfttokenid) external memberonly returns(uint256){
        require(nftmarketplace.available(_nfttokenid),"nft not available");
        Proposal storage proposal= proposals[numproposal];
        proposal.nfttokenid=_nfttokenid;
        proposal.deadline=block.timestamp+5 minutes; 
        numproposal++;
        return numproposal-1; // it should return the currect proposal id
    }
    function vote(uint256 proposalid,vote Vote) external memberonly activeproposal(proposalid) {
        Proposal storage proposal = proposals[proposalid];//loading up the struct
        uint256 voternftbalance= nft.balanceOf(msg.sender);
        uint256 numvotes;
        for(uint256 i; i< voternftbalance;++i){
            uint256 tokenid = nft.tokenOfOwnerByIndex(msg.sender, i);// assigns the id
            if(proposal.voters[tokenid]==false){
                numvotes++;
                proposal.voters[tokenid]==true;//used for voting now
            }
        }    
            require(numvotes > 0, "already voted");
            if(Vote == vote.yes){
                proposal.yes_votes+=numvotes;
                } else {
                    proposal.no_votes+=numvotes;
                }

    }

    function execute(uint256 proposalid)external memberonly inactiveproposal(proposalid){
        Proposal storage proposal = proposals[proposalid];//load the proposal 

        if(proposal.yes_votes > proposal.no_votes){
            uint256 nftprice= nftmarketplace.getprice();
            require(address(this).balance > nftprice, "not enough balance");
            nftmarketplace.purchace{value: nftprice}(proposal.nfttokenid);
        }
        proposal.executed = true;
    }

    function withdraw() external onlyowner{
        payable(owner()).transfer(address(this).balance);
    }


    receive() external payable  {}
    fallback() external payable {}
}     

