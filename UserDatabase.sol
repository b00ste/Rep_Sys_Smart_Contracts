// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnumerableSet.sol";
import "./UPOwner.sol";

contract UserDatabase is UPOwner {
    
    /*
    *   Storage for the username and the UP address.
    */
    
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private UPAddresses;
    
    using EnumerableSet for EnumerableSet.Bytes32Set;
    EnumerableSet.Bytes32Set private UPUsernames;
    
    /*
    *   Mapping an address to a index.
    *
    *   Used to querry for names in order to search throuh UPs.
    */
    
    mapping (bytes32 => uint256) usernameIndex;
    
    /*
    *   Correctly removing an signed up account.
    */
    
    function removeIndex(bytes32 _UPUsername) private {
        for(uint256 i = usernameIndex[_UPUsername]; i < UPUsernames.length(); i++) {
            usernameIndex[UPUsernames.at(i)] = i;
        }
        delete usernameIndex[_UPUsername];
    }
    
    /*
    *   Storing usersnames tied to UPs.
    */
    
    function signIn(bytes32 _UPUsername, address _UPAddress) public ownerOfUP(_UPAddress) returns(bool response_) {
        UPAddresses.add(_UPAddress);
        UPUsernames.add(_UPUsername);
        usernameIndex[_UPUsername] = UPUsernames.length() - 1;
        response_ = true;
    }
    
    /*
    *   Deleting an account.
    */
    
    function deleteAccount(bytes32 _UPUsername, address _UPAddress) public ownerOfUP(_UPAddress) returns(bool response_) {
        require(UPAddresses.at(usernameIndex[_UPUsername]) == _UPAddress, "UP username and address don't belong to eachother");
        UPAddresses.remove(_UPAddress);
        UPUsernames.remove(_UPUsername);
        removeIndex(_UPUsername);
        response_ = true;
    }
    
    /*
    *   Check if a certain UP username or address did sign un.
    */
    
    function checkUsername(bytes32 _UPUsername) public view returns(bool response_) {
        response_ = UPUsernames.contains(_UPUsername);
    }
    
    function checkAddress(address _UPAddress) public view returns(bool response_) {
        response_ = UPAddresses.contains(_UPAddress);
    }
    
    /*
    *   Get the UP username or the address by index.
    */
    
    function getUsername(uint256 _index) public view returns(bytes32 UPUsername_) {
        UPUsername_ = UPUsernames.at(_index);
    }
    
    function getAddress(uint256 _index) public view returns(address UPAddress_) {
        UPAddress_ = UPAddresses.at(_index);
    }
    
    /*
    *   Get the number of users.
    */
    function getUsers() public view returns(uint256 response_) {
        response_ = UPUsernames.length();
    }
    
    /*
    *   Get the address tied to a username.
    */
    
    function getAddressOfUsername(bytes32 _UPUsername) public view returns(address UPAddress_) {
        UPAddress_ = UPAddresses.at(usernameIndex[_UPUsername]);
    }
    
    /*
    *   Get a username's index.
    */
    
    function getUsernameIndex(bytes32 _UPUsername) public view returns(uint256 index_) {
        index_ = usernameIndex[_UPUsername];
    }
    
}