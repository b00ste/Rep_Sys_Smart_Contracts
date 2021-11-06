// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnumerableSet.sol";
import "./UPOwner.sol";
import "./UserDatabase.sol";

contract RepSys is UPOwner {
    
    /*
    *   Storing the address of this smart contract.
    *
    *   Purpose: to use in the Factory contract.
    */
    
    address public myAddress = address(this);
    
    /*
    *   Name of the reputation system.
    */
    
    bytes32 private name;
    
    /*
    *   Get reputation system's name.
    */
    
    function getName() public view returns(bytes32 name_) {
        name_ = name;
    }
    
    /*
    *   Address of the UP that created the reputation system.
    */
    
    address private creator;
    
    /*
    *   Get reputation system's creator.
    */
    
    function getCreator() public view returns(address creator_) {
        creator_ = creator;
    }
    
    /*
    *   Storage for users of a reputation system.
    */
    
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private usersStorage;
    
    /*
    *   Get the address of the user by index.
    */
    
    function getUsers(uint256 _index) public view returns(address address_) {
        address_ = usersStorage.at(_index);
    }
    
    /*
    *   Get the number of users.
    */
    
    function usersCount() public view returns(uint256 nrOfUsers_) {
        nrOfUsers_ = usersStorage.length();
    }
    
    /*
    *   Constructor used to create a reputation system from RepSysFactory.
    */
    
    constructor(bytes32 _name, address _creator) {
        name = _name;
        creator = _creator;
        usersStorage.add(creator);
        //  TODO send a genesis reputation token tied to _name reputation system to the creator.
    }
    
    /*
    *   Restricting access only for the participants of the reputation system.
    */
    
    modifier onlyParticipants (address _UPAddress) {
        require(usersStorage.contains(_UPAddress), "This UP isn't a part of this reputation system.");
        _;
    }
    
    /*
    *   Mapping for counting user's votes to get reputetion.
    *
    *   Gets reseted after required votes are reached.
    */
    
    mapping (address => address[]) userVotes;
    
    /*
    *   Create a voting proposal for a person to get
    *   a reputation token with a specific metadata.
    */
    
    function createVotingProposal(address _UPAddress, address _votingUPAddress, bytes32 _metadata) public ownerOfUP(_votingUPAddress) onlyParticipants(_votingUPAddress) {
        userVotes[_UPAddress].push(_votingUPAddress);
        // TODO create a token with _metadata.
    }
    
    /*
    *   Vote for a person to gain reputation.
    */
    
    function voteToAddToken(address _UPAddress, address _votingUPAddress) public onlyParticipants(_votingUPAddress) ownerOfUP(_votingUPAddress) {
        if(userVotes[_UPAddress].length <= usersStorage.length()/2) {
            userVotes[_UPAddress].push(_votingUPAddress);
        }
        else {
            //  TODO incentivize the users that have voted for _UPAddress
            if(!usersStorage.contains(_UPAddress)) {
                usersStorage.add(_UPAddress);
            }
            delete userVotes[_UPAddress];
            //  TODO send the token with _metadata to the _UPAddress.
        }
    }
    
}