pragma solidity ^0.6.0;
import "./Interfaces/Atoken.sol";
import "./Interfaces/ILendingPoolAddressesProvider.sol";
import "./Interfaces/ILendingPool.sol";
import "./Interfaces/IERC20.sol";

contract Pool {
    uint256 public depositAmount;
    uint256 public lockstart;
    uint256 public lockduration;
    uint256 public interest;
    address public creator;
    address atoken = address(0xD483B49F2d55D2c53D32bE6efF735cB001880F79);
    uint256 public totalDeposits;
    bool finished = false;
    //kovan dai
    address daiAddress = address(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);

    constructor(
        uint256 _deposit,
        uint256 _lockstart,
        uint256 _lockduration
    ) public {
        depositAmount = _deposit;
        lockstart = _lockstart;
        lockduration = _lockduration;
        creator = msg.sender;
    }

    function deposit(uint256 amount, address user) public {
        require(now < lockstart);
        ILendingPoolAddressesProvider provider = ILendingPoolAddressesProvider(
            address(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5)
        ); //kovan address
        ILendingPool lendingPool = ILendingPool(provider.getLendingPool());

        uint16 referral = 0;

        IERC20(daiAddress).approve(
            provider.getLendingPoolCore(),
            depositAmount
        );

        lendingPool.deposit(daiAddress, amount, referral);
        totalDeposits += depositAmount;
    }

    function withdrawDeposits(uint256 amount, bytes calldata data) public {
        require(now > lockstart + lockduration, "tokens are still locked");
        finished = true;
        interest = AToken(atoken).balanceOf(address(this)) - totalDeposits;
        AToken(atoken).redeem(amount);
    }

    function withdrawAll() public {
        require(now > lockstart + lockduration, "tokens are still locked");
        finished = true;
        interest = AToken(atoken).balanceOf(address(this)) - totalDeposits;
        AToken(atoken).redeem(totalDeposits);
    }

    function transferDepositToUser(address user) public {
        require(msg.sender == creator, "sender must the game contract");
        require(now > lockstart + lockduration, "tokens are still locked");
        require(finished == true, "Pool has not been redeemed");
        //require(deposited[msg.sender]==true);
        IERC20(daiAddress).transfer(user, depositAmount);
    }

    function transferInterestToUser(address user, uint256 amount) public {
        require(msg.sender == creator, "sender must the game contract");
        require(now > lockstart + lockduration, "tokens are still locked");
        require(finished == true, "Pool has not been redeemed");
        IERC20(daiAddress).transfer(user, amount);
    }
}
