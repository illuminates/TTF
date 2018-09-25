/**
contract Token {
    
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;
    address public migrationHost;
 
    function Token(address _migrationHost) {
        migrationHost = _migrationHost;
    }

    function migrateFrom(address _from, uint256 _value) public {
        require(migrationHost == msg.sender);
        require(balanceOf[_from] + _value > balanceOf[_from]); // overflow?
        balanceOf[_from] += _value;
        totalSupply += _value;
    }   
}*/