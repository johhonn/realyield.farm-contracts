
import "PoolHandler.sol";
import "./Interfaces/IERC20.sol"
import "./CropToken.sol";
contract Game is PoolHandler{
    uint gameinterval;
    uint first_game;
    uint[] defaultAllocation=[];
    uint[] defaultAllocation=[];
    uint defaultDeposit;
    address farmLocation;
    address DAI='';
    function getNextGame() external returns(uint){
        returns first_game+(((now-first_game)/gameinterval)+1)*gameinterval;
    };

    function depositToNextGame() external {
       uint game=getNextGame();
       let gamePool=getLendingPoolAddress(game);
       IERC20(DAI).transferFrom(msg.sender,gamePool,defaultDeposit);
       Pool(gamePool).deposit(defaultDeposit, '',msg.sender);
    };


    function withdrawStake(uint game) external{
        let gamePool=getLendingPoolAddress(game);
        Pool(gamePool).transferDepositToUser(msg.sender);
    };

    function withdrawInterest(uint game, uint[] memory Crops,uint[] memory balances) external return bool{
        CropToken(farmLocation).burn(msg.sender, Crops, balances);
        let (interestAllocations,
        totalTokens,
        depositValue,
         tokenHolder)=getLendingPool(game);
         
         let earnings=0
         for(uint i=0;i<Crops;i++){
             earnings +=getYield(Crops[i],Pool(tokenHolder).interest(),interestAllocations,totalTokens,balances[i]);
         }
        Pool(tokenHolder).transferInterestToUser(msg.sender,earnings);
    };
    function getYield(uint crop,uint interest,uint[] memory interestAllocations,uint[] totalTokens,uint userBalance) return (uint){
        let location=crop%100000;
        return((interest*userBalance)/(interestAllocations[location]*totalTokens[location]));
    }
    function initializeNextGame() public {
        let next=getNextGame();
        createPool(defaultAllocation,defaultAllocation,defaultDeposit,next);
    }

}