// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SkinNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("SkinNFT", "SKN") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function mintSkin(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI); // tokenURI is the Pinata CID (e.g., ipfs://<CID>)
        tokenCounter++;
        return newItemId;
    }
}