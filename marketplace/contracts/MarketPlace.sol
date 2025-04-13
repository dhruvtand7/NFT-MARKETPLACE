// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISkinNFT {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract Marketplace {
    struct Auction {
        address seller;
        uint256 tokenId;
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        bool isActive;
    }

    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => uint256) public salePrices;

    ISkinNFT public nftContract;
    address public admin;

    constructor(address _nftAddress) {
        nftContract = ISkinNFT(_nftAddress);
        admin = msg.sender;
    }

    // ========== FIXED PRICE LISTING ==========
    function listForSale(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        salePrices[tokenId] = price;
    }

    function buy(uint256 tokenId) external payable {
        uint256 price = salePrices[tokenId];
        require(price > 0, "NFT not for sale");
        require(msg.value >= price, "Insufficient funds");

        address seller = nftContract.ownerOf(tokenId);
        nftContract.safeTransferFrom(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);
        delete salePrices[tokenId];
    }

    // ========== AUCTION SYSTEM ==========
    function startAuction(uint256 tokenId, uint256 durationInSeconds) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");

        auctions[tokenId] = Auction({
            seller: msg.sender,
            tokenId: tokenId,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + durationInSeconds,
            isActive: true
        });
    }

    function bid(uint256 tokenId) external payable {
        Auction storage auction = auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp < auction.endTime, "Auction ended");
        require(msg.value > auction.highestBid, "Bid too low");

        // Refund previous bidder
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }

    function endAuction(uint256 tokenId) external {
        Auction storage auction = auctions[tokenId];
        require(auction.isActive, "Auction not active");
        require(block.timestamp >= auction.endTime, "Auction still ongoing");

        auction.isActive = false;

        if (auction.highestBidder != address(0)) {
            nftContract.safeTransferFrom(auction.seller, auction.highestBidder, tokenId);
            payable(auction.seller).transfer(auction.highestBid);
        }
    }
}
