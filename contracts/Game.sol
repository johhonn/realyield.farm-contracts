pragma solidity ^0.6.12;
import "./PoolHandler.sol";
import "./Interfaces/IERC20.sol";
import "./Pool.sol";
//import "./CropToken.sol";
contract Game is PoolHandler{
    uint gameinterval;
    uint first_game;
    uint[] defaultAllocation=[10,10];
    uint[] defaultLimits=[50,100];
    uint defaultDeposit;
    address farmLocation;
    address DAI=address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    mapping(address=>uint) gamePoolDeposits;
    function getNextGame() public view returns(uint){
        return first_game+(((now-first_game)/gameinterval)+1)*gameinterval;
    }

    function depositToNextGame() external {
       uint game=getNextGame();
       address gamePool=getLendingPoolAddress(game);
       if(gamePool==address(0)){
           gamePool = initializeNextGame();
       }
       IERC20(DAI).transferFrom(msg.sender,gamePool,defaultDeposit);
       Pool(gamePool).deposit(defaultDeposit, '',msg.sender);
       gamePoolDeposits[gamePool]=defaultDeposit;
    }


    function withdrawStake(uint game) external{
        require(gamePoolDeposits[msg.sender]>0,"pool is zero");
        address gamePool = getLendingPoolAddress(game);
        Pool(gamePool).transferDepositToUser(msg.sender);
        gamePoolDeposits[gamePool]=0;
    }

    function withdrawInterest(uint game, uint[] memory Crops,uint[] memory balances) external returns(bool){
        //CropToken(farmLocation).burn(msg.sender, Crops, balances);
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
        return((interest*userBalance)/(interestAllocations[location]*totalTokens[location]));
    }
    function initializeNextGame() public {
        uint next=getNextGame();
        createPool(defaultAllocation,defaultLimits,defaultDeposit,next,next,gameinterval);
    }

}