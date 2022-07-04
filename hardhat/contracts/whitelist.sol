//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract whitelist {
    // max number of people who can access the whitelist 
    uint8 public maxwhitelistedaddresses;
    //number of white listed addresses 
    uint8 public numwhitelistedaddresses;
    //mapping address to true or false (by default its false)
    mapping(address => bool) public whitelistedaddresses;

    constructor(uint8 _maxwhitelistedaddresses) {
        maxwhitelistedaddresses=_maxwhitelistedaddresses;

    }

    function addaddress() public {
        require(!whitelistedaddresses[msg.sender],"address already exsist");
        require(numwhitelistedaddresses < maxwhitelistedaddresses,"Max limit reached");
        whitelistedaddresses[msg.sender] = true;
        numwhitelistedaddresses +=1;

    }

}
