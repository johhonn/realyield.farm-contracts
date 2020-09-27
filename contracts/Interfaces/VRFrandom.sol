pragma solidity ^0.6.0;
interface VRFrandom {
    function getLatestRandom() external view returns (uint256);
    function getRandom(uint) external view returns (uint256);
   
}