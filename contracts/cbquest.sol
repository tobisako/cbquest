pragma solidity >=0.4.21 <0.6.0;

contract ICBQuestNFToken {
    function balanceOf(address owner) public view returns (uint256 balance);
    function ownerOf(uint256 tokenId) public view returns (address owner);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
    function getGameAssetParam(uint256 _tokenId) public view returns (string memory itemName, int attack, int difence, string memory ipfsHash);
}

contract CBQuest {
    address public owner;
    ICBQuestNFToken public cbQuestNFToken;
    struct PlayerInfo {
        address addr;
        string name;
        string picHash;
        uint level;
        uint hp;
        int attack;
        int difence;
        bool isEquipment;
        uint256 equipment_tokenId;
    }
    PlayerInfo[] public players;
    mapping(address => bool) public registered;
    uint public test;

    modifier playerRegistered {
        require(registered[msg.sender] == true);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCBQuestAssetAddress(address _addr) public {
        cbQuestNFToken = ICBQuestNFToken(_addr);
    }

    function newPlayer(string memory _name, uint _level, uint _hp, int _attack, int _difence, string memory _hash) public {
        require(registered[msg.sender] == false);
        players.push(PlayerInfo(msg.sender, _name, _hash, _level, _hp, _attack, _difence, false, 0));
        registered[msg.sender] = true;
    }

    function checkPlayerRegistered() public view returns (bool) {
        return registered[msg.sender];
    }

    function getPlayerIndex() public view playerRegistered returns (uint) {
        for(uint i = 0; i < players.length; i++) {
            if(players[i].addr == msg.sender) {
                return i;
            }
        }
        return uint(-1);
    }

    function getAssetBalance() public view returns (uint) {
        return cbQuestNFToken.balanceOf(msg.sender);
    }

    function getAssetInfoByTokenId(uint256 _tokenId) public view playerRegistered returns (string memory itemName, int attack, int difence, string memory ipfsHash) {
        (string memory _itemName, int _attack, int _difence, string memory _ipfsHash) = cbQuestNFToken.getGameAssetParam(_tokenId);
        return (_itemName, _attack, _difence, _ipfsHash);
    }

    function getAssetInfoByIndex(uint256 _index) public view playerRegistered returns (uint256 tokenId, string memory itemName, int attack, int difence, string memory ipfsHash) {
        uint256 _tokenId = cbQuestNFToken.tokenOfOwnerByIndex(msg.sender, _index);
        (string memory _itemName, int _attack, int _difence, string memory _ipfsHash) = cbQuestNFToken.getGameAssetParam(_tokenId);
        return (_tokenId, _itemName, _attack, _difence, _ipfsHash);
    }

    function setEquipmentTokenId(uint256 _tokenId) public playerRegistered {
        if(cbQuestNFToken.ownerOf(_tokenId) == msg.sender) {
            uint idx = getPlayerIndex();
            players[idx].isEquipment = true;
            players[idx].equipment_tokenId = _tokenId;
        } else {
            revert();
        }
    }
    
    function removeEquipment() public playerRegistered {
        uint idx = getPlayerIndex();
        players[idx].isEquipment = false;
        players[idx].equipment_tokenId = uint(-1);
    }

    function getEquipmentadditionalPower() public view playerRegistered returns (int addAttack, int addDifence, bool isEquipEnable) {
        int _addAttack;
        int _addDifence;
        bool _isEquipEnable;
        uint idx = getPlayerIndex();
        if(players[idx].isEquipment) {
            if(cbQuestNFToken.ownerOf(players[idx].equipment_tokenId) == msg.sender) {
                (,_addAttack, _addDifence,) = getAssetInfoByTokenId(players[idx].equipment_tokenId);
                _isEquipEnable = true;
            }
        }
        return (_addAttack, _addDifence, _isEquipEnable);
    }

    function getPlayersNum() public view returns (uint) {
        return players.length;
    }
}
