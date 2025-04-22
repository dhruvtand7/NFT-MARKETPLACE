const express = require('express');
const router = express.Router();
const multer = require('multer');
const { uploadFileToPinata, uploadMetadataToPinata } = require('./pinataService');

const upload = multer({ storage: multer.memoryStorage() });

router.post('/upload-nft', upload.single('image'), async (req, res) => {
  try {
    const { name, description } = req.body;
    const file = req.file;

    // Upload image to Pinata
    const imageCid = await uploadFileToPinata(file);

    // Create and upload metadata
    const metadata = {
      name,
      description,
      image: `ipfs://${imageCid}`,
    };
    const metadataCid = await uploadMetadataToPinata(metadata);

    res.json({ cid: metadataCid });
  } catch (error) {
    res.status(500).json({ error: 'Failed to upload to Pinata' });
  }
});

module.exports = router;