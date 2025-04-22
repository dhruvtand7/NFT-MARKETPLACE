# 🎮 CS:GO & Valorant Skin NFT Marketplace

A **decentralized NFT marketplace** where players can **buy, sell, and trade CS:GO and Valorant skins** using cryptocurrency. Each skin is minted as a unique **ERC721 NFT**, with metadata and images securely stored on **IPFS**. Smart contract escrows ensure **fair and trustless transactions**, eliminating scams and middlemen.

---

## 🚀 Features

- 🧬 **ERC721 NFT Tokenization** for each skin
- 🔐 **Smart Contract Escrow** ensures secure trades
- 💵 **Crypto Payments** in ETH, MATIC, USDC
- 🎨 **IPFS Metadata & Image Hosting**
- 💸 **Royalties** for original creators
- 🦊 **Wallet Integration** (MetaMask, WalletConnect)
- 🎮 **Filter by Game** (CS:GO / Valorant), rarity, etc.

---

## 🧠 Tech Stack

- **Solidity** – Smart contracts for NFTs and Marketplace
- **Truffle / Hardhat** – Development & deployment framework
- **React + Ethers.js** – Frontend interface
- **IPFS (Pinata / NFT.Storage)** – Off-chain data storage
- **ERC20 Support** – Payments in USDC, MATIC, ETH
- **MetaMask / WalletConnect** – Web3 wallet support

---

---

## ⚙️ Getting Started

### 1. Clone and Install

```bash
git clone https://github.com/dhruvv28/skin-marketplace.git
cd skin-marketplace
npm install
```

### 2. Environment Setup

Create a `.env` file in the root directory and add the following environment variables:

```env
MNEMONIC="your_mnemonic"
INFURA_API_KEY="your_infura_or_alchemy_key"
```

> ⚠️ **Important:** Keep this file private. Never commit it to GitHub.

---

### 3. Compile & Deploy Contracts

To compile and deploy the smart contracts on **Polygon**:

```bash
truffle compile
truffle migrate --network polygon
```

To deploy on **Sepolia Testnet**:

```bash
truffle migrate --network sepolia
```

---

### 4. Run the Frontend

```bash
cd frontend
npm install
npm start
```

Your frontend will be available at:

```
http://localhost:3000
```
npm start


