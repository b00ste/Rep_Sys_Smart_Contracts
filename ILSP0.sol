// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface ILSP0  /* is ERC165 */ {
         
    
    // ERC173
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    function owner() external view returns (address);
    
    function transferOwnership(address newOwner) external; // onlyOwner
    
    
    // ERC725Account (ERC725X + ERC725Y)
      
    event Executed(uint256 indexed _operation, address indexed _to, uint256 indexed  _value, bytes _data);
    
    event ValueReceived(address indexed sender, uint256 indexed value);
    
    event ContractCreated(uint256 indexed _operation, address indexed contractAddress, uint256 indexed  _value);
    
    event DataChanged(bytes32 indexed key, bytes value);
    
    
    function execute(uint256 operationType, address to, uint256 value, bytes memory data) external payable returns (bytes memory); // onlyOwner
    
    function getData(bytes32[] memory key) external view returns (bytes[] memory value);
    
    // LSP0 possible keys:
    // LSP1UniversalReceiverDelegate: 0x0cfc51aec37c55a4d0b1a65c6255c4bf2fbdf6277f3cc0730c45b828b6db8b47
    
    function setData(bytes32[] memory key, bytes[] memory value) external; // onlyOwner
    
    
    // ERC1271
    
    function isValidSignature(bytes32 _hash, bytes memory _signature) external view returns (bytes4 magicValue);
    
    
    // LSP1

    event UniversalReceiver(address indexed from, bytes32 indexed typeId, bytes indexed returnedValue, bytes receivedData);

    function universalReceiver(bytes32 typeId, bytes memory data) external returns (bytes memory);
    
    // IF LSP1UniversalReceiverDelegate key is set
    // THEN calls will be forwarded to the address given (UniversalReceiver even MUST still be fired)
}