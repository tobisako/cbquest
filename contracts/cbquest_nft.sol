pragma solidity >=0.4.21 <0.6.0;
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";

contract CBQuestNFToken is ERC721Full, ERC721Mintable {
    struct GameAssetParam {
        string itemName;
        int attack;
        int difence;
        string ipfsHash;
    }
    string constant name = "CBQuestAssetToken";
    string constant symbol = "CBQA";
    address public owner;
    GameAssetParam[] public params;
    event Mint(address from, uint256 tokenId, string tokenURI);

    constructor() ERC721Full(name, symbol) public {
        owner = msg.sender;
    }

    function mintGameAsset(string memory _itemName, int _attack, int _difence, string memory _ipfsHash, string memory _tokenURI) public {
        mintGameAsset(msg.sender, _itemName, _attack, _difence, _ipfsHash, _tokenURI);
    }

    function mintGameAsset(address _initOwner, string memory _itemName, int _attack, int _difence, string memory _ipfsHash, string memory _tokenURI) public {
        require(owner == msg.sender);
        GameAssetParam memory param = GameAssetParam(_itemName, _attack, _difence, _ipfsHash);
        uint256 _tokenId = params.push(param) - 1;
        _mint(_initOwner, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
        emit Mint(_initOwner, _tokenId, _tokenURI);
    }

    function getGameAssetParam(uint256 _tokenId) public view returns (string memory itemName, int attack, int difence, string memory ipfsHash) {
        return (params[_tokenId].itemName, params[_tokenId].attack, params[_tokenId].difence, params[_tokenId].ipfsHash);
    }

    function setIpfsHash(uint256 _tokenId, string memory _hash) public {
        params[_tokenId].ipfsHash = _hash;
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI) public {
        _setTokenURI(_tokenId, _tokenURI);
    }
}

