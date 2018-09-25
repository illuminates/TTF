pragma solidity ^0.4.24;

contract Ownable {
    address public owner;  

    event ChangeOwner(address newOwner);

    function constuctor() internal {
        owner = msg.sender;
    } 
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }  

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit ChangeOwner(owner);
    }
} 