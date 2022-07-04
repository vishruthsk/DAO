//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface iwhitelist{
    function whitelistedaddresses(address) external view returns(bool); 
    

}
