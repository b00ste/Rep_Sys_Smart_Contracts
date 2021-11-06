// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EnumerableSet.sol";
import "./UPOwner.sol";
import "./UserDatabase.sol";
import "./RepSys.sol";

contract RepSysFactory is UPOwner {
    
    /*
    *   Storage for reputation system names.
    */

    using EnumerableSet for EnumerableSet.Bytes32Set;
    EnumerableSet.Bytes32Set private repSysNamesStorage;
    
    /*
    *   Get the name of the reputation system by index.
    */
    
    function getRepSysName(uint256 _index) public view returns(bytes32 name_) {
        name_ = repSysNamesStorage.at(_index);
    }
    
    /*
    *   Storage for reputation system addresses.
    */

    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private repSysAddressesStorage;
    
    /*
    *   Get the address of the reputation system by index.
    */
    
    function getRepSysAddress(uint256 _index) public view returns(address address_) {
        address_ = repSysAddressesStorage.at(_index);
    }
    
    /*
    *   Get the number of reputation system's.
    */
    
    function repSysCount() public view returns(uint256 nrOfRepSys_) {
        nrOfRepSys_ = repSysNamesStorage.length();
    }
    
    /*
    *   Creating a reputation system.
    */
    
    function createRepSys(bytes32 _name, address _UPAddress) public ownerOfUP(_UPAddress) {
        RepSys newRepSys = new RepSys(_name, _UPAddress);
        repSysNamesStorage.add(_name);
        repSysAddressesStorage.add(newRepSys.myAddress());
        assert(repSysAddressesStorage.length() == repSysNamesStorage.length());
    }
    
}