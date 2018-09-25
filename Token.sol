import "./StandardToken.sol";
import "./Ownable.sol";
import "./MintableToken.sol";
import "./BurnableToken.sol";
import "./BurnableToken.sol";
import "./RoundSystem.sol";

contract Token is MintableToken, BurnableToken, RoundSystem {
    
    string public constant name = "Tardis Fund Token";
    string public constant symbol = "TTF";
    uint8 public constant decimals = 18; 

    /**investors*/
    address wallet1 = 0x9a6FaBB221Ea6a13efB555c7DDA76703414D1f34; // 10%
    address wallet2 = 0x4634d8496A20e15e122b9B82B346802Be8270Dfa; // 20%
    address wallet3 = 0xAB7e0293C435d329058cD4723453BA48F86294D4; // 5%
    address wallet4 = 0x6576e408B9e8eAb349dc059cAA5a20ede98968CD; // 20%

    /**reserved wallet */
    address admin = address(0);

    /**stages*/
    uint curStage = 0;

    /**local variables*/
    uint public minInvestment = 0;

    /**events*/
    event ChangeStage(string newStage, address owner);
    event CompleteICO(uint time);
    event ChangeMinInvetmentAmount(uint newMinAmount, address changer);
    event ChangeAdmin(address newAdmin, address changer);
    
    /**modifiers*/
        //modifier onlyZeroStage
    modifier onlyICOgo() {
        require(!ICOcomplete);
        _;
    }

    /**flags*/
    bool singleTimeMint = true;
    bool public ICOcomplete = false;

    /**constants*/
    uint constant addEmissAmount = 100000000  * 10 ** uint(decimals);
    
    function Token() public {
        owner             = msg.sender;
        totalSupply       = 100000000  * 10 ** uint(decimals);
        balances[this]    = 45000000   * 10 ** uint(decimals);
        balances[wallet1] = 10000000   * 10 ** uint(decimals);
        balances[wallet2] = 20000000   * 10 ** uint(decimals);
        balances[wallet3] = 5000000    * 10 ** uint(decimals);
        balances[wallet4] = 20000000   * 10 ** uint(decimals);
        cap = addEmissAmount;

        emit Transfer(address(0), this, totalSupply);
        emit Transfer(this, wallet1, balances[wallet1]);
        emit Transfer(this, wallet2, balances[wallet2]);
        emit Transfer(this, wallet3, balances[wallet3]);
        emit Transfer(this, wallet4, balances[wallet4]);        
    }

    function() public payable {
        buyTokens();
    }

    function buyTokens() public onlyICOgo payable {
        require(msg.value > minInvestment);
        uint toSend = getAmountOfTokens(msg.value);
        require(balances[this] >= toSend);
        balances[msg.sender] += toSend;
        balances[this] -= toSend;
        owner.transfer(msg.value);
        emit Transfer(this, msg.sender, toSend);
    }

    function buyTokens(address _reciver, uint _amount) private {
        require(balances[this] >= _amount);        
        balances[_reciver] += _amount;
        balances[this] -= _amount;
        emit Transfer(this, _reciver, _amount);
    }

    function getAmountOfTokens(uint etherAmount) public view returns(uint){
        return etherAmount.mul(getRoundPrice(curStage));
    }

    function setStage(uint _numStage) public onlyICOgo onlyOwner {
        require(getRoundFlag(_numStage) == true);
        if(_numStage == 4) {completeICO(); return;}
        curStage = _numStage;
        emit ChangeStage(getRoundName(curStage), owner);
    }

    function additionalEmission() public onlyICOgo onlyOwner {
        require(singleTimeMint == true);
        singleTimeMint = false;
        _mint(this, addEmissAmount);
    }

    function completeICO() public onlyOwner {
        ICOcomplete = true;
        curStage = 4;
        burnAfterICO();
        emit CompleteICO(now);
    }

    function burnAfterICO() private onlyOwner {
        _burn(this, balances[this]);
    }

    function sendTokens(address[] _recivers, uint[] _tokensAmount) external onlyOwner {
        require(_recivers.length <= 25);
        require(_recivers.length == _tokensAmount.length);

        for(uint i = 0; i < _recivers.length; i++) {
            buyTokens(_recivers[i], _tokensAmount[i]);
        }
    }

    function getStage() public view returns(string) {
        return getRoundName(curStage);
    }

    function setMinInvestment(uint _minInvestment) public {
        require(msg.sender == admin || msg.sender == owner);
        minInvestment = _minInvestment;
        emit ChangeMinInvetmentAmount(minInvestment, msg.sender);
    }

    function setAdmin(address _newAdmin) public onlyOwner {
        require(admin != _newAdmin);
        admin = _newAdmin;
        emit ChangeAdmin(admin, msg.sender);
    }
}
