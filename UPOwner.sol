// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract UPOwner {
    
    /*
    *   Verifying that the msg.sender is the owner of UP, only if UP isn't msg.sender.
    */
    
    modifier ownerOfUP (address _UPAddress) {
        ILSP0 UP = ILSP0(_UPAddress);
        if(_UPAddress != msg.sender) {
            require(UP.owner() == msg.sender, "User is not the owner of the UP");
        }
        _;
    }
    
}