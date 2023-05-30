// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Premium is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    string private _baseTokenURI;
    uint8 private _maxWhitelistedAddresses;
    Counters.Counter private _numAddressesWhitelisted;

    mapping(address => bool) private _whitelistedAddresses;

    constructor(
    ) ERC721("Blockchain Consciousness", "BC") {
        _baseTokenURI = "https://ipfs.thirdwebcdn.com/ipfs/bafybeiek4jfmztdgfhuprtndd6zkkzgbjlsqgigoggo7hgxskusy2w3xtq";
        _maxWhitelistedAddresses = 5;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function addAddressToWhitelist() public {
        require(msg.sender != address(0), "address cannot be of 0");
        require(
            !_whitelistedAddresses[msg.sender],
            "Sender has already been whitelisted"
        );
        require(
            totalSupply() < _maxWhitelistedAddresses,
            "More addresses can't be added, limit reached"
        );

        _numAddressesWhitelisted.increment();
        uint256 tokenId = _numAddressesWhitelisted.current();
        _safeMint(msg.sender, tokenId);
        _whitelistedAddresses[msg.sender] = true;
    }

    function isAddressWhitelisted(address addr) external view returns (bool) {
        return _whitelistedAddresses[addr];
    }

    function getMaxWhitelistedAddresses() public view returns (uint8) {
        return _maxWhitelistedAddresses;
    }

    function getNumAddressesWhitelisted() public view returns (uint256) {
        return _numAddressesWhitelisted.current();
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
}
