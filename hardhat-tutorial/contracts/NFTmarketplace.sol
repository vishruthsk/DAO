//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract NFTmarketplace {
    //tokenid is mapped to owner address
    mapping(uint256 => address) public token;
    uint256 nftprice=0.01 ether;
     
     function purchace(uint256 _tokenid) public payable{
         require(msg.value == nftprice," not enough ether");
         require(token[_tokenid]== address(0),"nft already sold");
         token[_tokenid]=msg.sender;

     }

     function getprice() external view returns(uint256){
         return nftprice;
     }
      function available(uint256 _tokenid) external view returns(bool){
          if(token[_tokenid]==address(0)){
              return true;
          }
          return false;

      } 
}