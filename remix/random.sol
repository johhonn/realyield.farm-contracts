pragma solidity 0.6.6;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/evm-contracts/src/v0.6/VRFConsumerBase.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/access/Ownable.sol";
contract random is VRFConsumerBase,Ownable {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    mapping(address => bool) callRandom;
    mapping(bytes32=>uint) public randomResult;
    mapping(uint=>bytes32) public getPingID;
    uint randomPings;
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xf490AC64087d59381faF8Bf49Da299C073aAC152
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor() 
        VRFConsumerBase(
            0xf490AC64087d59381faF8Bf49Da299C073aAC152, // VRF Coordinator
            0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
        ) public
    {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        
        callRandom[msg.sender]=true;
    }
    
    /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(callRandom[msg.sender]==true);
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
         randomPings+=1;
         randomResult[requestId]=randomness;
         getPingID[randomPings]=requestId;
    }
    
    function getLastRandomByReq(uint req) public  view returns(uint){
        return randomResult[getPingID[req]];
    }
    
    function getLastRandom() public view returns(uint){
        return randomResult[getPingID[randomPings]];
    }
    function addCaller(address a) public onlyOwner {
        callRandom[a]=true;
    }
    function removeCaller(address a) public onlyOwner {
        callRandom[a]=false;
    }
}
