// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract Orisa is ERC721Enumerable, Ownable {
    string baseTokenURI;

    bool public paused;
    bool public presaleStarted;

    uint256 public presaleEnded;
    uint256 public price = 0.01 ether;
    uint256 public tokenIds;
    uint256 public maxTokenIds = 20;

    mapping(address => bool) public hasMinted;

    IWhitelist whitelist;

    modifier onlyWhenNotPaused {
        require(!paused, "Contract currently paused");
        _;
    }

   
    constructor (string memory _baseTokenURI, address whitelistContract) ERC721("Orisa", "OS") {
        baseTokenURI = _baseTokenURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

   
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "This address was not whitelisted");
        require(tokenIds < maxTokenIds, "All 30 NFTs have been minted");
        require(msg.value >= price, "Ether sent is not correct");
        tokenIds++;

        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >=  presaleEnded, "Presale has not ended");
        require(tokenIds < maxTokenIds, "All 30 NFTs have been minted");
        require(msg.value >= price, "Send at least 0.01 ether");
        require(!hasMinted[msg.sender], "You have already minted; each address can mint only one NFT");

        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
        hasMinted[msg.sender] = true;
    }

   
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
    }

    
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}
}