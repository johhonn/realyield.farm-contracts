pragma solidity ^0.6.0;
interface AToken {
    function balanceOf(address account) external view returns (uint256);

    function redeem(uint256 _amount) external;
}