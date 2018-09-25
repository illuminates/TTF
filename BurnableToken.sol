import "./StandardToken.sol";
import "./Ownable.sol";

contract BurnableToken is StandardToken, Ownable {
    event TokensBurned(address indexed burner, uint256 value);
    
    function _burn(address _account, uint256 _amount) internal {
        require(_account != 0);
        require(_amount <= balances[_account]);

        totalSupply = totalSupply.sub(_amount);
        balances[_account] = balances[_account].sub(_amount);
        emit Transfer(_account, address(0), _amount);
        emit TokensBurned(_account, _amount);
    }
}