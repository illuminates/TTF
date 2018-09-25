import "./Ownable.sol";

contract RoundSystem is Ownable {

    string[] stagesName = ["Closed Pre-sale", "Pre-sale", "Sale1", "Sale2"];
    uint[] stagesPrice = [20000, 10000, 4000, 2000];  
    mapping(uint => round) public addRounds;
    struct round {
        bool flag;
        uint price;
        string name;
    }
  
    event addRound(string name, uint price);
    
    /**initialize start rounds */
    function RoundSystem() public {
        initStage(0, stagesName[0], stagesPrice[0]);
        initStage(1, stagesName[1], stagesPrice[1]);
        initStage(2, stagesName[2], stagesPrice[2]);
        initStage(3, stagesName[3], stagesPrice[3]);
        initStage(4, "Complete", 0);
    }

    function initStage(uint key, string name, uint price) private {
        round memory newRound;

        newRound.flag = true;
        newRound.price = price;
        newRound.name = name;

        addRounds[key] = newRound;
        emit addRound(name, price);
    }

    function addStage(uint key, string name, uint price) public onlyOwner {
        require(getRoundFlag(key) == false);
        round memory newRound;

        newRound.flag = true;
        newRound.price = price;
        newRound.name = name;
        
        addRounds[key] = newRound;
        emit addRound(name, price);
    }
    
    function getRoundPrice(uint _key) public view returns(uint) {
        return addRounds[_key].price;
    }

    function getRoundFlag(uint _key) public view returns(bool) {
        return addRounds[_key].flag;
    }
    
    function getRoundName(uint _key) public view returns(string) {
        return addRounds[_key].name;
    }
    
    function getRoundInf(uint _key) public view returns(string,uint) {
        return (addRounds[_key].name, addRounds[_key].price);
    }
    
}