// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISkinNFT {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract Marketplace {
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
    }

    struct Auction {
        uint256 tokenId;
        address seller;
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        bool isActive;
    }

    mapping(uint256 => Listing) public listings;
    mapping(uint256 => Auction) public auctions;

    ISkinNFT public nftContract;
    address public admin;

    constructor(address _nftAddress) {
        nftContract = ISkinNFT(_nftAddress);
        admin = msg.sender;
    }

    // ========== FIXED PRICE LISTING ==========
    function listForSale(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        require(price > 0, "Price must be greater than 0");
        listings[tokenId] = Listing({
            tokenId: tokenId,
            seller: msg.sender,
            price: price
        });
    }

    function buy(uint256 tokenId) external payable {
        Listing storage listing = listings[tokenId];
        require(listing.price > 0, "NFT not for sale");
        require(msg.value >= listing.price, "Insufficient funds");

        nftContract.safeTransferFrom(listing.seller, msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);
        delete listings[tokenId];
    }

    // ========== AUCTION SYSTEM ==========
    function startAuction(uint256 tokenId, uint256 durationInSeconds) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");

        auctions[tokenId] = Auction({
            tokenId: tokenId,
            seller: msg.sender,
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

    // Function to get all active listings
    function getActiveListings() public view returns (uint256[] memory, address[] memory, uint256[] memory) {
        uint256 count = 0;
        // First count active listings
        for (uint256 i = 0; i < 1000; i++) {
            if (listings[i].price > 0) {
                count++;
            }
        }

        // Initialize arrays with the correct size
        uint256[] memory tokenIds = new uint256[](count);
        address[] memory sellers = new address[](count);
        uint256[] memory prices = new uint256[](count);
        
        // Fill arrays with data
        uint256 index = 0;
        for (uint256 i = 0; i < 1000; i++) {
            if (listings[i].price > 0) {
                tokenIds[index] = i;
                sellers[index] = listings[i].seller;
                prices[index] = listings[i].price;
                index++;
            }
        }

        return (tokenIds, sellers, prices);
    }

    // Function to get all active auctions
    function getActiveAuctions() public view returns (
        uint256[] memory,
        address[] memory,
        uint256[] memory,
        address[] memory,
        uint256[] memory
    ) {
        uint256 count = 0;
        // First count active auctions
        for (uint256 i = 0; i < 1000; i++) {
            if (auctions[i].isActive) {
                count++;
            }
        }

        // Initialize arrays with the correct size
        uint256[] memory tokenIds = new uint256[](count);
        address[] memory sellers = new address[](count);
        uint256[] memory highestBids = new uint256[](count);
        address[] memory highestBidders = new address[](count);
        uint256[] memory endTimes = new uint256[](count);

        // Fill arrays with data
        uint256 index = 0;
        for (uint256 i = 0; i < 1000; i++) {
            if (auctions[i].isActive) {
                tokenIds[index] = i;
                sellers[index] = auctions[i].seller;
                highestBids[index] = auctions[i].highestBid;
                highestBidders[index] = auctions[i].highestBidder;
                endTimes[index] = auctions[i].endTime;
                index++;
            }
        }

        return (tokenIds, sellers, highestBids, highestBidders, endTimes);
    }
}