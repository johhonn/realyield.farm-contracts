pragma solidity ^0.6.0;




 

interface PodInterface {
     // Deposit 
     function deposit(uint256 amount, bytes calldata data) external;

     // Borrow
     function redeem(uint256 amount, bytes calldata data) external;
     
     // Balance Of underlyingAsset
     function balanceOfUnderlying(address user) external view returns (uint256);
     
     // Balance Of Shares
     function balanceOf(address tokenHolder) external view returns (uint256);
     
     // Pending deposit
     function pendingDeposit(address user) external view returns (uint256);
     
     // Withdraw Pending deposit
     function withdrawPendingDeposit(uint256 amount, bytes calldata data) external;
}