const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
require('dotenv').config();

const PINATA_API_KEY = process.env.PINATA_API_KEY;
const PINATA_API_SECRET = process.env.PINATA_API_SECRET;
const PINATA_GATEWAY = 'https://gateway.pinata.cloud/ipfs/';

// Upload a file to Pinata
async function uploadFileToPinata(file) {
  const url = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
  const formData = new FormData();

  if (file.path) {
    // File from disk
    formData.append('file', fs.createReadStream(file.path));
  } else {
    // File from memory
    formData.append('file', file.buffer, { filename: file.originalname });
  }

  try {
    const response = await axios.post(url, formData, {
      headers: {
        pinata_api_key: PINATA_API_KEY,
        pinata_api_secret: PINATA_API_SECRET,
        ...formData.getHeaders(),
      },
    });
    return `ipfs://${response.data.IpfsHash}`;
  } catch (error) {
    console.error('Pinata file upload error:', error);
    throw new Error('Failed to upload file to Pinata');
  }
}

// Upload JSON metadata to Pinata
async function uploadMetadataToPinata(metadata) {
  const url = 'https://api.pinata.cloud/pinning/pinJSONToIPFS';
  try {
    const response = await axios.post(url, metadata, {
      headers: {
        pinata_api_key: PINATA_API_KEY,
        pinata_api_secret: PINATA_API_SECRET,
      },
    });
    return `ipfs://${response.data.IpfsHash}`;
  } catch (error) {
    console.error('Pinata metadata upload error:', error);
    throw new Error('Failed to upload metadata to Pinata');
  }
}

// Fetch data from Pinata
async function getFromPinata(cid) {
  try {
    const response = await axios.get(`${PINATA_GATEWAY}${cid}`);
    return response.data;
  } catch (error) {
    console.error('Pinata fetch error:', error);
    throw new Error('Failed to fetch from Pinata');
  }
}

module.exports = { uploadFileToPinata, uploadMetadataToPinata, getFromPinata };