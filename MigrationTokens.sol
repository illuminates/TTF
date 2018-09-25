pragma solidity ^0.4.24;

interface MigrationAgent {
    function migrateFrom(address _from, uint256 _value) public;
}