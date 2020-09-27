pragma solidity ^0.6.0;
interface VRFrandom {
    function getLatestRandom() external view returns (uint256);

   
}