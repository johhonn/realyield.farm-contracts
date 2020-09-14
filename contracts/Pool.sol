pragma solidity ^0.6.0;
import "./Interfaces/Atoken.sol";
import "./Interfaces/ILendingPoolAddressesProvider.sol";
import "./Interfaces/ILendingPool.sol";
import "./Interfaces/IERC20.sol";
contract Pool {
    uint depositAmount;
    uint lockstart;
    uint lockduration;
    uint public interest;
    address creator;
    address atoken;
    uint public totalDeposits;
    bool finished=false;
    address daiAddress=address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    
    constructor(uint _deposit,uint _lockstart,uint _lockduration) public{
        depositAmount=_deposit;
        lockstart=_lockstart;
        lockduration=_lockduration;
        creator=msg.sender;
    }
    function deposit(uint256 amount, bytes calldata data,address user) public {
        require(now<lockstart);
        ILendingPoolAddressesProvider provider = ILendingPoolAddressesProvider(address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8)); // mainnet address, for other addresses: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
        ILendingPool lendingPool = ILendingPool(provider.getLendingPool());

        
        address daiAddress = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // mainnet DAI
        
        uint16 referral = 0;

      
        IERC20(daiAddress).approve(provider.getLendingPoolCore(), depositAmount);

    
        lendingPool.deposit(depositAmount, amount, referral);
        totalDeposits+=depositAmount;
    }

     
   
     
     function withdrawDeposits(uint256 amount, bytes calldata data) public{
         require(now>lockstart+lockduration,"");
         finished=true;
         interest=AToken(atoken).balanceOf(address(this))-totalDeposits;
         AToken(atoken).redeem(amount);
     }
    function transferDepositToUser(address user) public{
         require(msg.sender==creator,"");
         require(now>lockstart+lockduration,"");
         require(finished==true,"");
         //require(deposited[msg.sender]==true);
         IERC20(daiAddress).transfer(user,depositAmount);
         
    }
    function transferInterestToUser(address user,uint amount) public{
         require(msg.sender==creator,"");
         require(now>lockstart+lockduration,"");
         require(finished==true,"");
         IERC20(daiAddress).transfer(user,amount);
    }
}