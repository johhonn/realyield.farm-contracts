pragma solidity ^0.6.0;

interface ILendingPool{
function deposit(address _reserve, uint256 _amount, uint16 _referralCode ) external;


}