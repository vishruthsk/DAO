//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
import "./iwhitelist.sol";

contract NFT is ERC721Enumerable, Ownable {
    string _basetokenURI;
    iwhitelist whitelist;
    uint256 public presaleend;
    bool public presale;
    uint8 public maxtokenid=20;
    uint256 tokenids;
    uint256 _price = 0.01 ether;
    bool public _paused;
    modifier notpaused{
        require(!_paused,"currently paused");
        _;
    }
    constructor( string memory baseURI, address whitelistcontract) ERC721("Viper","VIP"){
        _basetokenURI= baseURI;
        whitelist= iwhitelist(whitelistcontract);


    }

    function startpresale() public onlyOwner{
        presale= true;
        presaleend = block.timestamp + 5 minutes;


    }

    function presalemint() public payable notpaused{
        require(presale && block.timestamp < 5 minutes , "the presale ended" );
        require(whitelist.whitelistedaddresses(msg.sender), " you aren not in whitelist");
        require(tokenids < maxtokenid , "max limit reached");
        require(msg.value >= _price, " not enough ether");
        tokenids +=1;
        _safeMint(msg.sender, tokenids); 
         

    }
    function mint() public payable notpaused{
        require(presale && block.timestamp > presaleend,"pre sale has not ended yet"); 
        require(tokenids < maxtokenid , "max limit reached");
        require(msg.value >= _price, "not enough ether");
        tokenids +=1;
        _safeMint(msg.sender, tokenids);

    }

    function withdraw() public onlyOwner{
        address _owner = owner();
        uint256 amount= address(this).balance;
        (bool sent, )=_owner.call{ value:amount}("");
        require(sent, "transfer failed");
    
    }

    function paused(bool val) public onlyOwner{
        _paused= val;
    }

    function _baseURI() internal view override returns (string memory) {
        return _basetokenURI;
    }
//if msg.data is empty
    receive() external payable {

    
    }
//if msg.data is not empty  
    fallback()external payable {

    }


}