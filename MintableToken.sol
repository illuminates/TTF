import "./BurnableToken.sol";


contract MintableToken is StandardToken, Ownable {
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;

    uint cap;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    modifier hasMintPermission() {
        require(msg.sender == owner);
        _;
    }
    
    function _mint(address _account, uint256 _amount) internal {
        require(_account != 0);
        totalSupply = totalSupply.add(_amount);
        balances[_account] = balances[_account].add(_amount);
        cap -= _amount;
        emit Mint(_account, _amount);
    }

    function finishMinting() private onlyOwner canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}