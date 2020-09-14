pragma solidity ^0.6.12;

import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155.sol';
import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol';
contract CropToken is ERC1155,ERC1155MintBurn{
    address game;
    modifier isGame(address sender){
        require(sender==game,"sender must be game manager");
        _;
    }
    function mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)  public isGame(msg.sender)  {
         _mint(_to, _id,  _amount, _data);
    }
    function burn(address _from, uint256[] memory _ids, uint256[] memory _amounts)  public isGame(msg.sender) {
        _batchBurn(_from,  _ids, _amounts);
    }

}