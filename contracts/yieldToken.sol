pragma solidity ^0.6.12;

import "multi-token-standard/contracts/tokens/ERC1155/ERC1155.sol";
import "multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract yieldToken is ERC1155, ERC1155MintBurn, Ownable {
    address game;

    constructor() public {}

    function setGame(address g) public onlyOwner {
        game = g;
    }

    modifier isGame(address sender) {
        require(sender == game, "sender must be game manager");
        _;
    }

    function mint(
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) public isGame(msg.sender) {
        _mint(_to, _id, _amount, _data);
    }

    function burn(
        address _from,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) public isGame(msg.sender) {
        _batchBurn(_from, _ids, _amounts);
    }

    function batchmint(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public isGame(msg.sender) {
        _batchMint(_to, _ids, _amounts, _data);
    }
}
