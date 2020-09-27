pragma solidity ^0.6.12;
import "./PoolHandler.sol";
import "./Interfaces/IERC20.sol";
import "./Interfaces/VRFrandom.sol";
import "./Pool.sol";
import "./Board.sol";
import "./yieldToken.sol";
import "./ERC1155Receiver.sol";

//import "@nomiclabs/buidler/console.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Game is PoolHandler,Board,Ownable,ERC1155Receiver{
    uint public gameinterval;
    uint public first_game;
    uint[] defaultAllocation;
    uint[] defaultLimits;
    uint defaultDeposit;
    address public farmLocation;
    address random;
    address DAI=address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    mapping(address=>mapping(uint=>uint)) public gamePoolDeposits;
    mapping(address=>mapping(uint=>uint)) public gamePoolPoints;
    mapping(address=>mapping(uint=>uint)) public gameOwnedPlots;
    mapping(address=>mapping(uint=>bool)) public userHarvested;
    mapping(uint=>mapping(uint=>uint)) public cropsMinted;
    mapping(uint=>bool) public yieldRandomSet;
    uint public PointWeight=10000;
    uint tokenDecimals=10**18;
    
    constructor(uint[] memory _allocation,uint[] memory _limits,uint _deposit, address _token,uint _gameinterval,uint _first_game,
    uint[] memory _seedSoilAffinities,uint[] memory _seedSproutAffinity,uint[] memory _seedSunlightAffinities, uint[] memory _seedPrices) 
    Board(_seedSoilAffinities,_seedSproutAffinity,_seedSunlightAffinities,_seedPrices) public{
        defaultAllocation=_allocation;
        defaultLimits=_limits;
        defaultDeposit=_deposit;
        farmLocation=_token;
        gameinterval=_gameinterval;
        first_game=_first_game;
    }

    modifier canPlant(address p,uint game){
        address gamePool=getLendingPoolAddress(game);
        require(gamePoolDeposits[p][game]>0,"no deposit");
        require(now>Pool(gamePool).lockstart()&&now<Pool(gamePool).lockstart()+Pool(gamePool).lockduration(),"Invalid Time Period");
        _;
    }
    modifier canHarvest(address p,uint game){
        address gamePool=getLendingPoolAddress(game);
        require(userHarvested[p][game]==false,"user has harvested");
        require(now>Pool(gamePool).lockstart()+Pool(gamePool).lockduration(),"Invalid Time Period");
        _;
    }
    function getSeedCost(uint[] memory _seeds,uint[] memory _amounts) public view returns(uint){
        uint cost=0;
        for(uint i=0;i<_seeds.length;i++){
            cost+=seedPrices[_seeds[i]]*_amounts[i];
        }
        return cost;
    }
    function plantSeeds(uint game,uint[] memory seedTypes,uint[] memory seedQuants) public canPlant(msg.sender,game) {
        uint cost= getSeedCost(seedTypes,seedQuants);gamePoolPoints[msg.sender][game];
        require(gamePoolPoints[msg.sender][game]>cost);
        gamePoolPoints[msg.sender][game]=gamePoolPoints[msg.sender][game]-cost;
        uint plot=gameOwnedPlots[msg.sender][game];
        require(plot+1>1,"user owns no plot") ;
        _plantSeeds(plot,game,seedQuants,seedTypes);
    }
    
    function getNextGame() public view returns(uint){
        //console.log(now);
        return first_game+(((now-first_game)/gameinterval)+1)*gameinterval;
    }
    function mintCropTokens(uint game,uint[] memory types,uint[] memory _amounts,address _to) internal{
         uint[] memory formatTokens=generatePoolTokenIDs(types,game);
         for(uint i=0;i<types.length;i++){
             cropsMinted[game][types[i]]+=_amounts[i];
         }
         yieldToken(farmLocation).batchmint(_to, formatTokens, _amounts,'');
    }
    function getYield(uint game) public{
        uint plot=gameOwnedPlots[msg.sender][game];
        (uint[] memory seeds,uint[] memory amounts)=getAllPlotPlantedSeeds(game ,plot);
        mintCropTokens(game,seeds,amounts,msg.sender);
    }

    function getMockYield(uint game) public {
        uint[] memory amounts=generateRandomSeedArray(msg.sender,game);
        uint[] memory types=new uint[](10);
        for(uint i=0;i<types.length;i++){
            types[i]=i;
        }
        mintCropTokens(game,types,amounts,msg.sender);
    }
    function depositToNextGame() external {
      
       uint game=getNextGame();
       require(gamePoolDeposits[msg.sender][game]==0,"user has already deposited");
       address gamePool=getLendingPoolAddress(game);
       if(gamePool==address(0)){
           gamePool = initializeNextGame();
       }
       IERC20(DAI).transferFrom(msg.sender,gamePool,defaultDeposit);
       Pool(gamePool).deposit(defaultDeposit,msg.sender);
      
       gamePoolDeposits[msg.sender][game]=defaultDeposit;
       gamePoolPoints[msg.sender][game]=PointWeight;
       gameOwnedPlots[msg.sender][game]=Pool(gamePool).totalDeposits();
    }
    function confirmRandom() public{
        require(msg.sender==random);
        uint game=first_game+(((now-first_game)/gameinterval)-1)*gameinterval;
        yieldRandomSet[game]=true;
    }

    function withdrawStake(uint game) external{
        require(gamePoolDeposits[msg.sender][game]>0,"pool is zero");
        address gamePool = getLendingPoolAddress(game);
        Pool(gamePool).transferDepositToUser(msg.sender);
        gamePoolDeposits[msg.sender][game]=0;
    }

    function withdrawInterest(uint game, uint[] memory Crops,uint[] memory balances) external returns(bool){
        yieldToken(farmLocation).safeBatchTransferFrom(msg.sender, address(this),Crops,balances, "");
        yieldToken(farmLocation).burn(msg.sender, Crops, balances);
        (uint[] memory interestAllocations,
         uint[] memory totalTokens,
         uint depositValue,
         address tokenHolder)=getLendingPool(game);
         
         uint earnings=0;
         for(uint i=0;i<Crops.length;i++){
             earnings +=getYield(Crops[i],Pool(tokenHolder).interest(),interestAllocations,totalTokens,balances[i],game);
         }
        Pool(tokenHolder).transferInterestToUser(msg.sender,earnings);
    }
    function getYield(uint crop,uint interest,uint[] memory interestAllocations,uint[] memory totalTokens,uint userBalance,uint game) public view returns (uint){
        uint location=crop%100000;
        return((interest*userBalance*10**16)/(numeratorFromTokenPercent(interestAllocations[location])*cropsMinted[game][location]));
    }
    function initializeNextGame() public returns(address) {
        uint next=getNextGame();
        return createPool(defaultAllocation,defaultLimits,defaultDeposit,next,next,gameinterval);
        
    }
    function numeratorFromTokenPercent(uint percent) public view returns(uint){
        return tokenDecimals/percent;
    }
    function generateRandomSeedArray(address user, uint  game) public view returns(uint[] memory ){
        uint random=VRFrandom(random).getLatestRandom();
        uint[] memory _tokens= new uint[](10);
        random=random*uint(user)*game;
        for(uint i=0;i<10;i++){
            _tokens[i]=(random**(10+i))%50;
        }
        return _tokens;
    }
}