pragma solidity ^0.6.12;

contract ERC1155Receiver {
    bytes4 internal constant ERC1155_RECEIVED_SIG = 0xf23a6e61;
    bytes4 internal constant ERC1155_BATCH_RECEIVED_SIG = 0xbc197c81;

    function onERC1155Received(
        address,
        address _from,
        uint256 _id,
        uint256,
        bytes memory _data
    ) public returns (bytes4) {
        return ERC1155_RECEIVED_SIG;
    }

    function onERC1155BatchReceived(
        address,
        address _from,
        uint256[] memory _ids,
        uint256[] memory,
        bytes memory _data
    ) public returns (bytes4) {
        return ERC1155_BATCH_RECEIVED_SIG;
    }
}
