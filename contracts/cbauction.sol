pragma solidity >=0.4.21 <0.6.0;
import "openzeppelin-solidity/contracts/token/ERC721/IERC721.sol";

contract CBAuction {
    address public owner;
    IERC721 public cbQuestAssetNFT;
    enum phases {exhibit, bid, bidend, closed}
    phases public phase = phases.exhibit;
    address payable public exhibitorAddress;
    uint256 public exhibitionTokenId;
    address[] biddersList;
    mapping(address => string) bidderName;
    mapping(address => uint) bidderBalance;
    address public successfulBbidderAddress;
    event BidLog(address bidder, string name, uint addvalue);
    event WidhDrawLog(address from, address to, uint value);

    modifier atPhase(phases _phase) {
        require(phase == _phase);
        _;
    }

    constructor() public payable {
        owner = msg.sender;
    }

    function exhibitNFT(address _addr, uint256 _tokenId) public atPhase(phases.exhibit) {
        set721ContractAddress(_addr);
        if(checkApproved(_tokenId) == address(this)) {
            exhibitionTokenId = _tokenId;
            exhibitorAddress = msg.sender;
            phase = phases.bid;
        }
    }

    function set721ContractAddress(address _addr) public {
        cbQuestAssetNFT = IERC721(_addr);
    }

    function checkApproved(uint256 _tokenId) public view returns (address) {
        if(address(cbQuestAssetNFT) != address(0)) {
            return cbQuestAssetNFT.getApproved(_tokenId);
        }
        return address(-1);
    }

    function firstBid(string memory _name) public payable {
        require(bidderBalance[msg.sender] == 0);
        addBid();
        bidderName[msg.sender] = _name;
        biddersList.push(msg.sender);
    }

    function addBid() public payable {
        require(msg.value > 0);
        bidderBalance[msg.sender] += msg.value;
        emit BidLog(msg.sender, bidderName[msg.sender], msg.value);
    }

    function getBiddersNum() public view returns (uint) {
        return biddersList.length;
    }

    function getBidderInfoByIndex(uint _idx) public view returns (address, string memory, uint) {
        return (biddersList[_idx], bidderName[biddersList[_idx]], bidderBalance[biddersList[_idx]]);
    }

    function getBidderInfoByAddr(address _addr) public view returns (string memory, uint) {
        return (bidderName[_addr], bidderBalance[_addr]);
    }

    function closeAuction() public atPhase(phases.bid) {
        require(exhibitorAddress == msg.sender);
        (successfulBbidderAddress,,) = calcHighestBidder();
        phase = phases.bidend;
    }

    function calcHighestBidder() public view atPhase(phases.bid) returns (address, uint, string memory) {
        address highestBidderAddress;
        uint highestBidBalance;
        for(uint i = 0; i < biddersList.length; i++) {
            if(bidderBalance[biddersList[i]] > highestBidBalance) {
                highestBidBalance = bidderBalance[biddersList[i]];
                highestBidderAddress = biddersList[i];
            }
        }
        return (highestBidderAddress, highestBidBalance, bidderName[highestBidderAddress]);
    }

    function transferNFT() public atPhase(phases.bidend) {
        require(exhibitorAddress == msg.sender);
        cbQuestAssetNFT.safeTransferFrom(exhibitorAddress, successfulBbidderAddress, exhibitionTokenId);
        exhibitorAddress.transfer(bidderBalance[successfulBbidderAddress]);
        bidderBalance[successfulBbidderAddress] = 0;
        phase = phases.closed;
    }

    function withDrawBidders() public atPhase(phases.closed) {
        require(bidderBalance[msg.sender] > 0);
        msg.sender.transfer(bidderBalance[msg.sender]);
        bidderBalance[msg.sender] = 0;
        emit WidhDrawLog(address(this), msg.sender, bidderBalance[msg.sender]);
    }

    function withDrawAuctionMaster() public {
        require(owner == msg.sender);
        msg.sender.transfer(address(this).balance);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function test_FORCE_CLOSED() public {
        phase = phases.closed;
    }
}
