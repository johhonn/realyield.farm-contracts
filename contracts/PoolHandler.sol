// File: @openzeppelin\contracts-ethereum-package\contracts\Initializable.sol
pragma solidity ^0.6.12;
import "./Interfaces/IERC20.sol";
import "./libraries/safeMath.sol";
import "./Pool.sol";

contract PoolHandler {
    using safeMath for uint256;

    mapping(uint256 => pool) stakingPools;

    struct pool {
        uint256[] interestAllocations;
        uint256[] totalTokens;
        uint256 depositValue;
        address tokenHolder;
    }

    function generatePoolTokenIDs(uint256[] memory types, uint256 _id)
        public
        pure
        returns (uint256[] memory)
    {
        for (uint256 i = 0; i < types.length; i++) {
            types[i] = _id * 100000 + types[i];
        }
        return types;
    }

    function getLendingPool(uint256 pool)
        public
        view
        returns (
            uint256[] memory,
            uint256[] memory,
            uint256,
            address
        )
    {
        return (
            stakingPools[pool].interestAllocations,
            stakingPools[pool].totalTokens,
            stakingPools[pool].depositValue,
            stakingPools[pool].tokenHolder
        );
    }

    function getLendingPoolAddress(uint256 pool) public view returns (address) {
        return stakingPools[pool].tokenHolder;
    }

    function createPool(
        uint256[] memory _interestAllocations,
        uint256[] memory _totalTokens,
        uint256 _depositValue,
        uint256 _id,
        uint256 _lockstart,
        uint256 _lockduration
    ) internal returns (address) {
        Pool _Pool = new Pool(_depositValue, _lockstart, _lockduration);
        stakingPools[_id] = pool(
            _interestAllocations,
            _totalTokens,
            _depositValue,
            address(_Pool)
        );
        return address(_Pool);
    }
}
