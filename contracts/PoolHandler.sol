// File: @openzeppelin\contracts-ethereum-package\contracts\Initializable.sol
pragma solidity ^0.6.12;
import './Interfaces/IERC20.sol';
import './libraries/SafeMath.sol';
import './Pool.sol';







contract PoolHandler {
    
    using SafeMath for uint256;
	
	mapping(uint=>pool) stakingPools;
    
	struct pool{
        uint[] interestAllocations;
        uint[] totalTokens;
        uint depositValue;
        address tokenHolder;
        
        
    }
    function generatePoolTokenIDs(uint[] memory types,uint _id) public pure returns(uint[] memory){
        
        for(uint i=0;i<types.length;i++){
            types[i]=_id*100000+types[i];
        }
        return types;
    }
	function getLendingPool(uint pool)  public view returns(uint[] memory,uint[] memory ,uint,address){
        return (stakingPools[pool].interestAllocations,stakingPools[pool].totalTokens,stakingPools[pool].depositValue,stakingPools[pool].tokenHolder);
    }
    function getLendingPoolAddress(uint pool) public  view returns(address){
        return stakingPools[pool].tokenHolder;
    }
    function createPool(uint[] memory _interestAllocations,uint[] memory _totalTokens,uint _depositValue,uint _id,uint _lockstart,uint _lockduration) internal returns(address){
        Pool _Pool=new Pool(_depositValue,_lockstart, _lockduration);
        stakingPools[_id]=pool(_interestAllocations,_totalTokens,_depositValue,address(_Pool));
        return address(_Pool);
    }	  
    
    
}