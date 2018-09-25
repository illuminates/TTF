import "./Token.sol";
import "./MigrationTokens.sol";

contract TokenMigration is Token {
    address public migrationAgent;

    // Migrate tokens to the new token contract
    function migrate() external {
        require(migrationAgent != 0);
        uint value = balances[msg.sender];
        balances[msg.sender] -= value;
        totalSupply -= value;
        MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
    }

    function setMigrationAgent(address _agent) external {
        require(msg.sender == owner && migrationAgent == address(0));
        migrationAgent = _agent;
    }
}