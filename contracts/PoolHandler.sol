// File: @openzeppelin\contracts-ethereum-package\contracts\Initializable.sol
import './Interfaces/IERC20.sol';

pragma solidity >=0.4.24 <0.7.0;







contract PoolHandler {
    
    using SafeMath for uint256;
	
	mapping(uint=>pool) pools;
    
	struct pool{
        uint[] interestAllocations,
        uint[] totalTokens,
        uint depositValue,
        address tokenHolder,
        
        
    }
    function generatePoolTokenIDs(uint[] memory types,uint _id) pure returns(uint[]){
        
        for(uint i=0;i<types.length;i++){
            types[i]=_id*100000+types[i];
        }
        return types;
    }
	function getLendingPool(uint pool)  view returns(uint[],uint[],uint,address){
        return (stakingPools[pool].gameinterval,stakingPools[pool].gameinterval,stakingPools[pool].depositValue,stakingPools[pool].tokenHolder);
    }
    function getLendingPoolAddress(uint pool) view returns(address){
        return stakingPools[pool];
    }
    function createPool(uint[] memory _interestAllocations,uint[] memory _totalTokens,uint _depositValue,uint _id,uint _lockstart,uint _lockduration) internal{
        address Pool=new Pod(_depositValue,_lockstart, _lockduration);
        pools[id]=pool(_interestAllocations,_totalTokens,_depositValue,Pool);
    }	  
    
    
}