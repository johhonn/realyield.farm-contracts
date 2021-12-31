pragma solidity ^0.6.12;
import "./PoolHandler.sol";
import "./Interfaces/IERC20.sol";
import "./Pool.sol";
import "./Board.sol";
import "./yieldToken.sol";
import "./ERC1155Receiver.sol";
//import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//import '@openzeppelin/contracts/roles/MinterRole.sol';
contract Game is PoolHandler, Board, Ownable, ERC1155Receiver {
    uint256 public gameinterval;
    uint256 public first_game;
    uint256[] defaultAllocation;
    uint256[] defaultLimits;
    uint256 defaultDeposit;
    address public farmLocation;
    address VRFrandom;
    address DAI = address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    mapping(address => mapping(uint256 => uint256)) public gamePoolDeposits;
    mapping(address => mapping(uint256 => uint256)) public gamePoolPoints;
    mapping(address => mapping(uint256 => uint256)) public gameOwnedPlots;
    mapping(address => mapping(uint256 => bool)) public userHarvested;

    mapping(uint256 => bool) public yieldRandomSet;
    uint256 public PointWeight = 10000;
    uint256 tokenDecimals = 10**18;

    constructor(
        uint256[] memory _allocation,
        uint256[] memory _limits,
        uint256 _deposit,
        address _token,
        uint256 _gameinterval,
        uint256 _first_game,
        uint256[] memory _seedSoilAffinities,
        uint256[] memory _seedSproutAffinity,
        uint256[] memory _seedSunlightAffinities,
        uint256[] memory _seedPrices
    )
        public
        Board(
            _seedSoilAffinities,
            _seedSproutAffinity,
            _seedSunlightAffinities,
            _seedPrices
        )
    {
        defaultAllocation = _allocation;
        defaultLimits = _limits;
        defaultDeposit = _deposit;
        farmLocation = _token;
        gameinterval = _gameinterval;
        first_game = _first_game;
    }

    modifier canPlant(address p, uint256 game) {
        address gamePool = getLendingPoolAddress(game);
        require(gamePoolDeposits[p][game] > 0, "no deposit");
        require(
            now > Pool(gamePool).lockstart() &&
                now <
                Pool(gamePool).lockstart() + Pool(gamePool).lockduration(),
            "Invalid Time Period"
        );
        _;
    }
    modifier canHarvest(address p, uint256 game) {
        address gamePool = getLendingPoolAddress(game);
        require(userHarvested[p][game] == false, "user has harvested");
        require(
            now > Pool(gamePool).lockstart() + Pool(gamePool).lockduration(),
            "Invalid Time Period"
        );
        _;
    }

    function getSeedCost(uint256[] memory _seeds, uint256[] memory _amounts)
        public
        view
        returns (uint256)
    {
        uint256 cost = 0;
        for (uint256 i = 0; i < _seeds.length; i++) {
            cost += seedPrices[_seeds[i]] * _amounts[i];
        }
        return cost;
    }

    function plantSeeds(
        uint256 game,
        uint256[] memory seedTypes,
        uint256[] memory seedQuants
    ) public canPlant(msg.sender, game) {
        uint256 cost = getSeedCost(seedTypes, seedQuants);
        gamePoolPoints[msg.sender][game];
        require(gamePoolPoints[msg.sender][game] > cost);
        gamePoolPoints[msg.sender][game] =
            gamePoolPoints[msg.sender][game] -
            cost;
        uint256 plot = gameOwnedPlots[msg.sender][game];
        require(plot + 1 > 1, "user owns no plot");
        _plantSeeds(plot, game, seedQuants, seedTypes);
    }

    function getNextGame() public view returns (uint256) {
        //console.log(now);
        return
            first_game +
            (((now - first_game) / gameinterval) + 1) *
            gameinterval;
    }

    function mintCropTokens(
        uint256 game,
        uint256[] memory types,
        uint256[] memory _amounts,
        address _to
    ) internal {
        uint256[] memory formatTokens = generatePoolTokenIDs(types, game);

        yieldToken(farmLocation).batchmint(_to, formatTokens, _amounts, "");
    }

    function getYield(uint256 game) public {
        uint256 plot = gameOwnedPlots[msg.sender][game];
        (
            uint256[] memory seeds,
            uint256[] memory amounts
        ) = getAllPlotPlantedSeeds(game, plot);
        mintCropTokens(game, seeds, amounts, msg.sender);
    }

    function depositToNextGame() external {
        uint256 game = getNextGame();
        address gamePool = getLendingPoolAddress(game);
        if (gamePool == address(0)) {
            gamePool = initializeNextGame();
        }
        IERC20(DAI).transferFrom(msg.sender, gamePool, defaultDeposit);
        Pool(gamePool).deposit(defaultDeposit, msg.sender);
        gamePoolDeposits[msg.sender][game] = defaultDeposit;
        gamePoolPoints[msg.sender][game] = PointWeight;
        gameOwnedPlots[msg.sender][game] = Pool(gamePool).totalDeposits();
    }

    function confirmRandom() public {
        require(msg.sender == VRFrandom);
        uint256 game = first_game +
            (((now - first_game) / gameinterval) - 1) *
            gameinterval;
        yieldRandomSet[game] = true;
    }

    function withdrawStake(uint256 game) external {
        require(gamePoolDeposits[msg.sender][game] > 0, "pool is zero");
        address gamePool = getLendingPoolAddress(game);
        Pool(gamePool).transferDepositToUser(msg.sender);
        gamePoolDeposits[msg.sender][game] = 0;
    }

    function withdrawInterest(
        uint256 game,
        uint256[] memory Crops,
        uint256[] memory balances
    ) external returns (bool) {
        yieldToken(farmLocation).safeBatchTransferFrom(
            msg.sender,
            address(this),
            Crops,
            balances,
            ""
        );
        yieldToken(farmLocation).burn(msg.sender, Crops, balances);
        (
            uint256[] memory interestAllocations,
            uint256[] memory totalTokens,
            uint256 depositValue,
            address tokenHolder
        ) = getLendingPool(game);

        uint256 earnings = 0;
        for (uint256 i = 0; i < Crops.length; i++) {
            earnings += getYield(
                Crops[i],
                Pool(tokenHolder).interest(),
                interestAllocations,
                totalTokens,
                balances[i]
            );
        }
        Pool(tokenHolder).transferInterestToUser(msg.sender, earnings);
    }

    function getYield(
        uint256 crop,
        uint256 interest,
        uint256[] memory interestAllocations,
        uint256[] memory totalTokens,
        uint256 userBalance
    ) public view returns (uint256) {
        uint256 location = crop % 100000;
        return ((interest * userBalance * 10**16) /
            (numeratorFromTokenPercent(interestAllocations[location]) *
                totalTokens[location]));
    }

    function initializeNextGame() public returns (address) {
        uint256 next = getNextGame();
        return
            createPool(
                defaultAllocation,
                defaultLimits,
                defaultDeposit,
                next,
                next,
                gameinterval
            );
    }

    function numeratorFromTokenPercent(uint256 percent)
        public
        view
        returns (uint256)
    {
        return tokenDecimals / percent;
    }
}
