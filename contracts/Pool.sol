pragma solidity ^0.6.0;
import "Atoken.sol";

contract Pool {
    uint depositAmount;
    uint lockstart;
    uint lockduration;
    uint public interest;
    address creator;
    address atoken;
    uint public totalDeposits;
    bool finished=false;
    mapping(address=>bool) deposited;
    constructor(uint _deposit,uint _lockstart,uint _lockduration){
        depositAmount=_deposit;
        lockstart=_lockstart;
        lockduration=_lockduration;
        creator=msg.sender;
    }
    function deposit(uint256 amount, bytes calldata data,address user) external{
        require(now<lockstart);
        LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8)); // mainnet address, for other addresses: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
        LendingPool lendingPool = LendingPool(provider.getLendingPool());

        
        address daiAddress = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // mainnet DAI
        
        uint16 referral = 0;

      
        IERC20(daiAddress).approve(provider.getLendingPoolCore(), depositAmount);

    
        lendingPool.deposit(depositAmount, amount, referral);
        totalDeposits+=depositAmount;
    };

     
   
     
     function withdrawDeposits(uint256 amount, bytes calldata data) external{
         require(now>lockstart+lockduration,"");
         finished=true;
         interest=Atoken(atoken).balanceOf(address(this))-totalDeposits;
         Atoken(atoken).redeem(amount);
     };
    function transferDepositToUser(address user){
         require(msg.sender==creator,"");
         require(now>lockstart+lockduration,"");
         require(finished==true,"");
         require(deposited[msg.sender]==true);
         IERC20(daiAddress).transfer(user,depositAmount);
         
    }
    function transferInterestToUser(address user,uint amount){
         require(msg.sender==creator,"");
         require(now>lockstart+lockduration,"");
         require(finished==true,"");
         IERC20(daiAddress).transfer(user,amount));
    }
}