// File: contracts/Interfaces/IERC20.sol

pragma solidity ^0.6.0;
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/libraries/safeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library safeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/Interfaces/Atoken.sol

pragma solidity ^0.6.0;
interface AToken {
    function balanceOf(address account) external view returns (uint256);

    function redeem(uint256 _amount) external;
}

// File: contracts/Interfaces/ILendingPoolAddressesProvider.sol

pragma solidity ^0.6.0;

/**
@title ILendingPoolAddressesProvider interface
@notice provides the interface to fetch the LendingPoolCore address
 */

interface ILendingPoolAddressesProvider {

    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getLendingPoolCore() external view returns (address payable);
    function setLendingPoolCoreImpl(address _lendingPoolCore) external;

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPoolDataProvider() external view returns (address);
    function setLendingPoolDataProviderImpl(address _provider) external;

    function getLendingPoolParametersProvider() external view returns (address);
    function setLendingPoolParametersProviderImpl(address _parametersProvider) external;

    function getTokenDistributor() external view returns (address);
    function setTokenDistributor(address _tokenDistributor) external;


    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiquidationManager() external view returns (address);
    function setLendingPoolLiquidationManager(address _manager) external;

    function getLendingPoolManager() external view returns (address);
    function setLendingPoolManager(address _lendingPoolManager) external;

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;

}

// File: contracts/Interfaces/ILendingPool.sol

pragma solidity ^0.6.0;

interface ILendingPool{
function deposit(address _reserve, uint256 _amount, uint16 _referralCode ) external;


}

// File: contracts/Pool.sol

pragma solidity ^0.6.0;




contract Pool {
    uint public depositAmount;
    uint public lockstart;
    uint public lockduration;
    uint public interest;
    address public creator;
    address atoken=address(0xD483B49F2d55D2c53D32bE6efF735cB001880F79);
    uint public totalDeposits;
    bool finished=false;
    //kovan dai
    address daiAddress=address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    
    constructor(uint _deposit,uint _lockstart,uint _lockduration) public{
        depositAmount=_deposit;
        lockstart=_lockstart;
        lockduration=_lockduration;
        creator=msg.sender;
    }
    function deposit(uint256 amount, address user) public {
        require(now<lockstart);
        ILendingPoolAddressesProvider provider = ILendingPoolAddressesProvider(address(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5)); //kovan address
        ILendingPool lendingPool = ILendingPool(provider.getLendingPool());

        
       
        
        uint16 referral = 0;

      
        IERC20(daiAddress).approve(provider.getLendingPoolCore(), depositAmount);

    
        lendingPool.deposit(daiAddress, amount, referral);
        totalDeposits+=depositAmount;
    }

     
   
     
     function withdrawDeposits(uint256 amount, bytes calldata data) public{
         require(now>lockstart+lockduration,"tokens are still locked");
         finished=true;
         interest=AToken(atoken).balanceOf(address(this))-totalDeposits;
         AToken(atoken).redeem(amount);
     }
    function transferDepositToUser(address user) public{
         require(msg.sender==creator,"sender must the game contract");
         require(now>lockstart+lockduration,"tokens are still locked");
         require(finished==true,"Pool has not been redeemed");
         //require(deposited[msg.sender]==true);
         IERC20(daiAddress).transfer(user,depositAmount);
         
    }
    function transferInterestToUser(address user,uint amount) public{
         require(msg.sender==creator,"sender must the game contract");
         require(now>lockstart+lockduration,"tokens are still locked");
         require(finished==true,"Pool has not been redeemed");
         IERC20(daiAddress).transfer(user,amount);
    }
}

// File: contracts/PoolHandler.sol

// File: @openzeppelin\contracts-ethereum-package\contracts\Initializable.sol
pragma solidity ^0.6.12;










contract PoolHandler {
    
    using safeMath for uint256;
	
	mapping(uint=>pool) stakingPools;
    
	struct pool{
        uint[] interestAllocations;
        uint[] totalTokens;
        uint depositValue;
        address tokenHolder;
        
        
    }
    function generatePoolTokenIDs(uint[] memory types,uint _id) public pure returns(uint[] memory){
        
        for(uint i=0;i<types.length;i++){
            types[i]=_id*100000+types[i];
        }
        return types;
    }
	function getLendingPool(uint pool)  public view returns(uint[] memory,uint[] memory ,uint,address){
        return (stakingPools[pool].interestAllocations,stakingPools[pool].totalTokens,stakingPools[pool].depositValue,stakingPools[pool].tokenHolder);
    }
    function getLendingPoolAddress(uint pool) public  view returns(address){
        return stakingPools[pool].tokenHolder;
    }
    function createPool(uint[] memory _interestAllocations,uint[] memory _totalTokens,uint _depositValue,uint _id,uint _lockstart,uint _lockduration) internal returns(address){
        Pool _Pool=new Pool(_depositValue,_lockstart, _lockduration);
        stakingPools[_id]=pool(_interestAllocations,_totalTokens,_depositValue,address(_Pool));
        return address(_Pool);
    }	  
    
    
}

// File: contracts/Board.sol

pragma solidity ^0.6.12;

contract Board{
    struct plot{
        uint soil;
        uint sunlight;
        uint temperature;
        uint security;
        address renter;
        mapping(uint=>uint) PlantedSeeds;
    }
    uint decimals=10**18;
    uint totalSeedTypes=10;
    mapping(uint=> plot[4096]) farms;

    uint[] seedSoilAffinities;
    uint[] seedSproutAffinity;
    uint[] seedSunlightAffinities;

    uint[] seedPrices;

    constructor(uint[] memory _seedSoilAffinities,uint[] memory _seedSproutAffinity,uint[] memory _seedSunlightAffinities, uint[] memory _seedPrices) public {
        seedSoilAffinities= _seedSoilAffinities;
        seedSproutAffinity=_seedSproutAffinity;
        seedSunlightAffinities= _seedSunlightAffinities;
        
        seedPrices=_seedPrices;
    }

    function getFarmProperties(uint _plot,uint _game) public view returns(uint,uint,uint,uint,address){
        return (farms[_game][_plot].soil,farms[_game][_plot].sunlight,farms[_game][_plot].temperature,farms[_game][_plot].security,farms[_game][_plot].renter);
    }
    function getPlotPlantingProperties(uint _plot,uint _game) public view returns(uint,uint,uint){
        return (farms[_game][_plot].soil,farms[_game][_plot].sunlight,farms[_game][_plot].temperature);
    }

    function _plantSeeds(uint _plot,uint game,uint[] memory amounts,uint[] memory seeds) internal{
        plot storage p = farms[game][_plot];
        if(p.soil==0){
            setPlotProperties(game, _plot);
        }
        for(uint i=0;i<seeds.length;i++){
            p.PlantedSeeds[seeds[i]]=amounts[i];
        }
    }
    function calculateSeedScore(uint seed,uint _plot,uint game) public view returns(uint){
        (uint _soil,uint _sun,uint temp)=getPlotPlantingProperties(_plot,game);
        return absDiff(seedSoilAffinities[seed],_soil)+absDiff(seedSunlightAffinities[seed],_sun)+absDiff(seedSunlightAffinities[seed],temp);
    }
    function getRenter(uint _g,uint _p) public view returns(address){
        return farms[_g][_p].renter;
    }
    function getGrownRatio(uint seed,uint rv,uint score) public view returns(uint ratio){
        if(score>=10000){
            ratio=0;
        }else{
        uint ratio=rv%10000-score+seedSproutAffinity[seed];
        }
    }
    function getSeedGrowthResult(uint seed,uint _plot,uint quantity,uint game) public view returns(uint){
        uint score =calculateSeedScore(seed,_plot,game);
        uint growth= getGrownRatio(seed,getLatestRandom(),score);
        return ((quantity*growth*decimals)/(20000*decimals));
    }

  function getAllPlotPlantedSeeds(uint game ,uint _plot) public view returns(uint[] memory ,uint[] memory ){
        plot storage pp=farms[game][_plot];
        uint[] memory seedlist= new uint[](totalSeedTypes);
        uint[] memory seedAmounts= new uint[](totalSeedTypes);
        for(uint i=0;i<totalSeedTypes;i++){
            if(pp.PlantedSeeds[i]>0){
                console.log(i);
                console.log(pp.PlantedSeeds[i]);
                seedlist[i]=i;
                seedAmounts[i]=pp.PlantedSeeds[i];
            }
        }
        return(seedlist,seedAmounts);
    }

    function getTotalScore(uint plot,uint[] memory amounts,uint[] memory seeds,uint _game) public view returns(uint[] memory ){
        uint[] memory seedYield= new uint[](totalSeedTypes);
        for(uint i=0;i<seeds.length;i++){
            seedYield[i]=getSeedGrowthResult(seeds[i],plot,amounts[i],_game);
        }

    }
    function getLatestRandom()  public view  returns(uint){
        return getRandom(now);
    }
    function getRandom(uint seed) public view returns(uint256){
     return uint256(
            keccak256(abi.encodePacked(block.difficulty, now,seed))
        );
    }
    function setPlotProperties(uint _game,uint _plot) internal{
        uint r=getRandom(_game*_plot);
        plot storage p=farms[_game][_plot];
        p.soil=1000+(r%5000);
        p.sunlight=1000+((r%5000)**2)%5000;
        p.temperature=1000+((r%5000)**3)%5000;
        p.security=1000+((r%5000)**4)%5000;
    }
    function absDiff(uint a,uint b) public pure returns(uint Difference){
        if(a>b){
        Difference= (a-b);
        }else{
        Difference= (b-a);
        }
    }

}

// File: multi-token-standard/contracts/utils/SafeMath.sol

pragma solidity ^0.6.8;


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {

  /**
   * @dev Multiplies two unsigned integers, reverts on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath#mul: OVERFLOW");

    return c;
  }

  /**
   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath#sub: UNDERFLOW");
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Adds two unsigned integers, reverts on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath#add: OVERFLOW");

    return c; 
  }

  /**
   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
   * reverts when dividing by zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
    return a % b;
  }
}

// File: multi-token-standard/contracts/interfaces/IERC1155TokenReceiver.sol

pragma solidity ^0.6.8;

/**
 * @dev ERC-1155 interface for accepting safe transfers.
 */
interface IERC1155TokenReceiver {

  /**
   * @notice Handle the receipt of a single ERC1155 token type
   * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
   * This function MAY throw to revert and reject the transfer
   * Return of other amount than the magic value MUST result in the transaction being reverted
   * Note: The token contract address is always the message sender
   * @param _operator  The address which called the `safeTransferFrom` function
   * @param _from      The address which previously owned the token
   * @param _id        The id of the token being transferred
   * @param _amount    The amount of tokens being transferred
   * @param _data      Additional data with no specified format
   * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
   */
  function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);

  /**
   * @notice Handle the receipt of multiple ERC1155 token types
   * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
   * This function MAY throw to revert and reject the transfer
   * Return of other amount than the magic value WILL result in the transaction being reverted
   * Note: The token contract address is always the message sender
   * @param _operator  The address which called the `safeBatchTransferFrom` function
   * @param _from      The address which previously owned the token
   * @param _ids       An array containing ids of each token being transferred
   * @param _amounts   An array containing amounts of each token being transferred
   * @param _data      Additional data with no specified format
   * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
   */
  function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
}

// File: multi-token-standard/contracts/interfaces/IERC1155.sol

pragma solidity ^0.6.8;


interface IERC1155 {

  /****************************************|
  |                 Events                 |
  |_______________________________________*/

  /**
   * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
   *   Operator MUST be msg.sender
   *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
   *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
   *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
   *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
   */
  event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);

  /**
   * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
   *   Operator MUST be msg.sender
   *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
   *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
   *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
   *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
   */
  event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);

  /**
   * @dev MUST emit when an approval is updated
   */
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

  /**
   * @dev MUST emit when the URI is updated for a token ID
   *   URIs are defined in RFC 3986
   *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
   */
  event URI(string _amount, uint256 indexed _id);


  /****************************************|
  |                Functions               |
  |_______________________________________*/

  /**
    * @notice Transfers amount of an _id from the _from address to the _to address specified
    * @dev MUST emit TransferSingle event on success
    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
    * MUST throw if `_to` is the zero address
    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
    * MUST throw on any other error
    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    * @param _from    Source address
    * @param _to      Target address
    * @param _id      ID of the token type
    * @param _amount  Transfered amount
    * @param _data    Additional data with no specified format, sent in call to `_to`
    */
  function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;

  /**
    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
    * @dev MUST emit TransferBatch event on success
    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
    * MUST throw if `_to` is the zero address
    * MUST throw if length of `_ids` is not the same as length of `_amounts`
    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
    * MUST throw on any other error
    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
    * @param _from     Source addresses
    * @param _to       Target addresses
    * @param _ids      IDs of each token type
    * @param _amounts  Transfer amounts per token type
    * @param _data     Additional data with no specified format, sent in call to `_to`
  */
  function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;

  /**
   * @notice Get the balance of an account's Tokens
   * @param _owner  The address of the token holder
   * @param _id     ID of the Token
   * @return        The _owner's balance of the Token type requested
   */
  function balanceOf(address _owner, uint256 _id) external view returns (uint256);

  /**
   * @notice Get the balance of multiple account/token pairs
   * @param _owners The addresses of the token holders
   * @param _ids    ID of the Tokens
   * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
   */
  function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

  /**
   * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
   * @dev MUST emit the ApprovalForAll event on success
   * @param _operator  Address to add to the set of authorized operators
   * @param _approved  True if the operator is approved, false to revoke approval
   */
  function setApprovalForAll(address _operator, bool _approved) external;

  /**
   * @notice Queries the approval status of an operator for a given owner
   * @param _owner     The owner of the Tokens
   * @param _operator  Address of authorized operator
   * @return isOperator True if the operator is approved, false if not
   */
  function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
}

// File: multi-token-standard/contracts/utils/Address.sol

pragma solidity ^0.6.8;


/**
 * Utility library of inline functions on addresses
 */
library Address {

  // Default hash for EOA accounts returned by extcodehash
  bytes32 constant internal ACCOUNT_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract.
   * @param _address address of the account to check
   * @return Whether the target address is a contract
   */
  function isContract(address _address) internal view returns (bool) {
    bytes32 codehash;

    // Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address or if it has a non-zero code hash or account hash
    assembly { codehash := extcodehash(_address) }
    return (codehash != 0x0 && codehash != ACCOUNT_HASH);
  }
}

// File: multi-token-standard/contracts/utils/ERC165.sol

pragma solidity ^0.6.8;

abstract contract ERC165 {
  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceID The interface identifier, as specified in ERC-165
   * @return `true` if the contract implements `_interfaceID`
   */
  function supportsInterface(bytes4 _interfaceID) virtual public pure returns (bool) {
    return _interfaceID == this.supportsInterface.selector;
  }
}

// File: multi-token-standard/contracts/tokens/ERC1155/ERC1155.sol

pragma solidity ^0.6.8;







/**
 * @dev Implementation of Multi-Token Standard contract
 */
contract ERC1155 is IERC1155, ERC165 {
  using SafeMath for uint256;
  using Address for address;

  /***********************************|
  |        Variables and Events       |
  |__________________________________*/

  // onReceive function signatures
  bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
  bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;

  // Objects balances
  mapping (address => mapping(uint256 => uint256)) internal balances;

  // Operator Functions
  mapping (address => mapping(address => bool)) internal operators;


  /***********************************|
  |     Public Transfer Functions     |
  |__________________________________*/

  /**
   * @notice Transfers amount amount of an _id from the _from address to the _to address specified
   * @param _from    Source address
   * @param _to      Target address
   * @param _id      ID of the token type
   * @param _amount  Transfered amount
   * @param _data    Additional data with no specified format, sent in call to `_to`
   */
  function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
    public override
  {
    require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
    require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
    // require(_amount <= balances[_from][_id]) is not necessary since checked with safemath operations

    _safeTransferFrom(_from, _to, _id, _amount);
    _callonERC1155Received(_from, _to, _id, _amount, gasleft(), _data);
  }

  /**
   * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
   * @param _from     Source addresses
   * @param _to       Target addresses
   * @param _ids      IDs of each token type
   * @param _amounts  Transfer amounts per token type
   * @param _data     Additional data with no specified format, sent in call to `_to`
   */
  function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
    public override
  {
    // Requirements
    require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
    require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");

    _safeBatchTransferFrom(_from, _to, _ids, _amounts);
    _callonERC1155BatchReceived(_from, _to, _ids, _amounts, gasleft(), _data);
  }


  /***********************************|
  |    Internal Transfer Functions    |
  |__________________________________*/

  /**
   * @notice Transfers amount amount of an _id from the _from address to the _to address specified
   * @param _from    Source address
   * @param _to      Target address
   * @param _id      ID of the token type
   * @param _amount  Transfered amount
   */
  function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
    internal
  {
    // Update balances
    balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
    balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount

    // Emit event
    emit TransferSingle(msg.sender, _from, _to, _id, _amount);
  }

  /**
   * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
   */
  function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, uint256 _gasLimit, bytes memory _data)
    internal
  {
    // Check if recipient is contract
    if (_to.isContract()) {
      bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received{gas: _gasLimit}(msg.sender, _from, _id, _amount, _data);
      require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
    }
  }

  /**
   * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
   * @param _from     Source addresses
   * @param _to       Target addresses
   * @param _ids      IDs of each token type
   * @param _amounts  Transfer amounts per token type
   */
  function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
    internal
  {
    require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");

    // Number of transfer to execute
    uint256 nTransfer = _ids.length;

    // Executing all transfers
    for (uint256 i = 0; i < nTransfer; i++) {
      // Update storage balance of previous bin
      balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
      balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
    }

    // Emit event
    emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
  }

  /**
   * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
   */
  function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, uint256 _gasLimit, bytes memory _data)
    internal
  {
    // Pass data if recipient is contract
    if (_to.isContract()) {
      bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived{gas: _gasLimit}(msg.sender, _from, _ids, _amounts, _data);
      require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
    }
  }


  /***********************************|
  |         Operator Functions        |
  |__________________________________*/

  /**
   * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
   * @param _operator  Address to add to the set of authorized operators
   * @param _approved  True if the operator is approved, false to revoke approval
   */
  function setApprovalForAll(address _operator, bool _approved)
    external override
  {
    // Update operator status
    operators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  /**
   * @notice Queries the approval status of an operator for a given owner
   * @param _owner     The owner of the Tokens
   * @param _operator  Address of authorized operator
   * @return isOperator True if the operator is approved, false if not
   */
  function isApprovedForAll(address _owner, address _operator)
    public override view returns (bool isOperator)
  {
    return operators[_owner][_operator];
  }


  /***********************************|
  |         Balance Functions         |
  |__________________________________*/

  /**
   * @notice Get the balance of an account's Tokens
   * @param _owner  The address of the token holder
   * @param _id     ID of the Token
   * @return The _owner's balance of the Token type requested
   */
  function balanceOf(address _owner, uint256 _id)
    public override view returns (uint256)
  {
    return balances[_owner][_id];
  }

  /**
   * @notice Get the balance of multiple account/token pairs
   * @param _owners The addresses of the token holders
   * @param _ids    ID of the Tokens
   * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
   */
  function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
    public override view returns (uint256[] memory)
  {
    require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");

    // Variables
    uint256[] memory batchBalances = new uint256[](_owners.length);

    // Iterate over each owner and token ID
    for (uint256 i = 0; i < _owners.length; i++) {
      batchBalances[i] = balances[_owners[i]][_ids[i]];
    }

    return batchBalances;
  }


  /***********************************|
  |          ERC165 Functions         |
  |__________________________________*/

  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceID  The interface identifier, as specified in ERC-165
   * @return `true` if the contract implements `_interfaceID` and
   */
  function supportsInterface(bytes4 _interfaceID) public override virtual pure returns (bool) {
    if (_interfaceID == type(IERC1155).interfaceId) {
      return true;
    }
    return super.supportsInterface(_interfaceID);
  }
}

// File: multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol

pragma solidity ^0.6.8;



/**
 * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
 *      a parent contract to be executed as they are `internal` functions
 */
contract ERC1155MintBurn is ERC1155 {

  /****************************************|
  |            Minting Functions           |
  |_______________________________________*/

  /**
   * @notice Mint _amount of tokens of a given id
   * @param _to      The address to mint tokens to
   * @param _id      Token id to mint
   * @param _amount  The amount to be minted
   * @param _data    Data to pass if receiver is contract
   */
  function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
    internal
  {
    // Add _amount
    balances[_to][_id] = balances[_to][_id].add(_amount);

    // Emit event
    emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);

    // Calling onReceive method if recipient is contract
    _callonERC1155Received(address(0x0), _to, _id, _amount, gasleft(), _data);
  }

  /**
   * @notice Mint tokens for each ids in _ids
   * @param _to       The address to mint tokens to
   * @param _ids      Array of ids to mint
   * @param _amounts  Array of amount of tokens to mint per id
   * @param _data    Data to pass if receiver is contract
   */
  function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
    internal
  {
    require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");

    // Number of mints to execute
    uint256 nMint = _ids.length;

     // Executing all minting
    for (uint256 i = 0; i < nMint; i++) {
      // Update storage balance
      balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
    }

    // Emit batch mint event
    emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);

    // Calling onReceive method if recipient is contract
    _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, gasleft(), _data);
  }


  /****************************************|
  |            Burning Functions           |
  |_______________________________________*/

  /**
   * @notice Burn _amount of tokens of a given token id
   * @param _from    The address to burn tokens from
   * @param _id      Token id to burn
   * @param _amount  The amount to be burned
   */
  function _burn(address _from, uint256 _id, uint256 _amount)
    internal
  {
    //Substract _amount
    balances[_from][_id] = balances[_from][_id].sub(_amount);

    // Emit event
    emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
  }

  /**
   * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
   * @param _from     The address to burn tokens from
   * @param _ids      Array of token ids to burn
   * @param _amounts  Array of the amount to be burned
   */
  function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
    internal
  {
    // Number of mints to execute
    uint256 nBurn = _ids.length;
    require(nBurn == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");

    // Executing all minting
    for (uint256 i = 0; i < nBurn; i++) {
      // Update storage balance
      balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
    }

    // Emit batch mint event
    emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
  }
}

// File: contracts/yieldToken.sol

pragma solidity ^0.6.12;


contract yieldToken is ERC1155,ERC1155MintBurn{
    address game;
    modifier isGame(address sender){
        require(sender==game,"sender must be game manager");
        _;
    }
    function mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)  public isGame(msg.sender)  {
         _mint(_to, _id,  _amount, _data);
    }
    function burn(address _from, uint256[] memory _ids, uint256[] memory _amounts)  public isGame(msg.sender) {
        _batchBurn(_from,  _ids, _amounts);
    }
    function batchmint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)  public isGame(msg.sender)  {
         _batchMint(_to, _ids, _amounts,_data);
    }
}

// File: contracts/ERC1155Receiver.sol

pragma solidity ^0.6.12;


contract ERC1155Receiver{
    bytes4 constant internal ERC1155_RECEIVED_SIG = 0xf23a6e61;
    bytes4 constant internal ERC1155_BATCH_RECEIVED_SIG= 0xbc197c81;
    function onERC1155Received(address, address _from, uint256 _id, uint256, bytes memory _data)
    public returns(bytes4)
     {
  
      return ERC1155_RECEIVED_SIG;
    }  
    

  function onERC1155BatchReceived(address, address _from, uint256[] memory _ids, uint256[] memory, bytes memory _data)
    public returns(bytes4)
  {
  
      return ERC1155_BATCH_RECEIVED_SIG;
      }

}

// File: @openzeppelin/contracts/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/Game.sol

pragma solidity ^0.6.12;






//import "@nomiclabs/buidler/console.sol";

//import '@openzeppelin/contracts/roles/MinterRole.sol';
contract Game is PoolHandler,Board,Ownable,ERC1155Receiver{
    uint public gameinterval;
    uint public first_game;
    uint[] defaultAllocation;
    uint[] defaultLimits;
    uint defaultDeposit;
    address public farmLocation;
    address VRFrandom;
    address DAI=address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    mapping(address=>mapping(uint=>uint)) public gamePoolDeposits;
    mapping(address=>mapping(uint=>uint)) public gamePoolPoints;
    mapping(address=>mapping(uint=>uint)) public gameOwnedPlots;
    mapping(address=>mapping(uint=>bool)) public userHarvested;
     
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
        
         
         yieldToken(farmLocation).batchmint(_to, formatTokens, _amounts,'');
    }
    function getYield(uint game) public{
        uint plot=gameOwnedPlots[msg.sender][game];
        (uint[] memory seeds,uint[] memory amounts)=getAllPlotPlantedSeeds(game ,plot);
        mintCropTokens(game,seeds,amounts,msg.sender);
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
       gamePoolPoints[msg.sender][game]=PointWeight;
       gameOwnedPlots[msg.sender][game]=Pool(gamePool).totalDeposits();
    }
    function confirmRandom() public{
        require(msg.sender==VRFrandom);
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
