pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "./Interfaces/VRFrandom.sol";
import '@openzeppelin/contracts/access/Ownable.sol';


contract reocurringRandom is ChainlinkClient, Ownable {
    enum RSTATE { OPEN, CLOSED, CALCULATING_WINNER }
    RSTATE public state;
    uint256 public lotteryId;
    address public RVF;
    uint256 public interval;
    bool public cancelled;
   
    
    // 1 LINK
    uint256 ORACLE_PAYMENT = 1 * 10 ** 18;
    // Alarm stuff
    address CHAINLINK_ALARM_ORACLE = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
    bytes32 CHAINLINK_ALARM_JOB_ID = "a7ab70d561d34eb49e9b1612fd2e044b";
  
    constructor(address _rvf, uint _interval) public
    {
        setPublicChainlinkToken();
        lotteryId = 1;
        //state = RSTATE.CLOSED;
        RVF=_rvf;
    
        interval=_interval;
    }
  /**
   * @notice Allows the owner to withdraw any LINK balance on the contract
   */
  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
  }
  
    
  function start_new_lottery(uint256 duration) internal {
   // require(state == RSTATE.CLOSED, "can't start a new lottery yet");
    //require(cancelled==false,"cancelled must be false ");
   // state= RSTATE.OPEN;
    Chainlink.Request memory req = buildChainlinkRequest(CHAINLINK_ALARM_JOB_ID, address(this), this.fulfill_alarm.selector);
    req.addUint("until", now + duration* 1 seconds);
    sendChainlinkRequestTo(CHAINLINK_ALARM_ORACLE, req, ORACLE_PAYMENT);
  }
  
  function fulfill_alarm(bytes32 _requestId)
    public
    recordChainlinkFulfillment(_requestId)
      {
        //require(state == RSTATE.OPEN, "The lottery hasn't even started!");
        // add a require here so that only the oracle contract can
        // call the fulfill alarm method
       // state = RSTATE.CALCULATING_WINNER;
        lotteryId = lotteryId + 1;
        VRFrandom(RVF).getRandomNumber(lotteryId);
       // state= RSTATE.CLOSED;
        start_new_lottery(interval);
    }
    function testVRF() public  onlyOwner(){
       VRFrandom(RVF).getRandomNumber(now);
    }
    function cancelRequests() public  onlyOwner(){
          cancelled=true;
    }
    function setInterval(uint i) public onlyOwner(){
        interval=i;
    }
    function initialize() public onlyOwner(){
      start_new_lottery(interval);
    }
}
