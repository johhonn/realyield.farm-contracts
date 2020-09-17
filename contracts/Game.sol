pragma solidity ^0.6.12;
import "./PoolHandler.sol";
import "./Interfaces/IERC20.sol";
import "./Pool.sol";
import "./yieldToken.sol";
//import "@nomiclabs/buidler/console.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
contract Game is PoolHandler{
    uint public gameinterval;
    uint public first_game;
    uint[] defaultAllocation;
    uint[] defaultLimits;
    uint defaultDeposit;
    address public farmLocation;
    address DAI=address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    mapping(address=>mapping(uint=>uint)) gamePoolDeposits;
    mapping(address=>mapping(uint=>uint)) gamePoolPoints;
    uint public PointWeight=1000;
    uint tokenDecimals=10**18;

    constructor(uint[] memory _allocation,uint[] memory _limits,uint _deposit, address _token,uint _gameinterval,uint _first_game) public{
        defaultAllocation=_allocation;
        defaultLimits=_limits;
        defaultDeposit=_deposit;
        farmLocation=_token;
        gameinterval=_gameinterval;
        first_game=_first_game;
    }
    function getNextGame() public view returns(uint){
        //console.log(now);
        return first_game+(((now-first_game)/gameinterval)+1)*gameinterval;
    }

    function depositToNextGame() external {
       uint game=getNextGame();
       address gamePool=getLendingPoolAddress(game);
       if(gamePool==address(0)){
           gamePool = initializeNextGame();
       }
       IERC20(DAI).transferFrom(msg.sender,gamePool,defaultDeposit);
       Pool(gamePool).deposit(defaultDeposit,msg.sender);
       gamePoolDeposits[msg.sender][game]=defaultDeposit;
       gamePoolPoints[msg.sender][game]=100*PointWeight;
    }


    function withdrawStake(uint game) external{
        require(gamePoolDeposits[msg.sender][game]>0,"pool is zero");
        address gamePool = getLendingPoolAddress(game);
        Pool(gamePool).transferDepositToUser(msg.sender);
        gamePoolDeposits[msg.sender][game]=0;
    }

    function withdrawInterest(uint game, uint[] memory Crops,uint[] memory balances) external returns(bool){
        yieldToken(farmLocation).burn(msg.sender, Crops, balances);
        (uint[] memory interestAllocations,
         uint[] memory totalTokens,
         uint depositValue,
         address tokenHolder)=getLendingPool(game);
         
         uint earnings=0;
         for(uint i=0;i<Crops.length;i++){
             earnings +=getYield(Crops[i],Pool(tokenHolder).interest(),interestAllocations,totalTokens,balances[i]);
         }
        Pool(tokenHolder).transferInterestToUser(msg.sender,earnings);
    }
    function getYield(uint crop,uint interest,uint[] memory interestAllocations,uint[] memory totalTokens,uint userBalance) public view returns (uint){
        uint location=crop%100000;
        return((interest*userBalance*10**16)/(numeratorFromTokenPercent(interestAllocations[location])*totalTokens[location]));
    }
    function initializeNextGame() public returns(address) {
        uint next=getNextGame();
        return createPool(defaultAllocation,defaultLimits,defaultDeposit,next,next,gameinterval);
        
    }
    function numeratorFromTokenPercent(uint percent) public view returns(uint){
        return tokenDecimals/percent;
    }
}