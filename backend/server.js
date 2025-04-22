require('dotenv').config();
const express = require('express');
const cors = require('cors');
const multer = require('multer');
const { uploadFileToPinata, uploadMetadataToPinata } = require('./pinataService');
const pinataRoutes = require('./pinataRoutes');

const app = express();
const upload = multer({ dest: 'uploads/' });

app.use(cors()); // Enable CORS
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api', pinataRoutes);

app.post('/upload-image', upload.single('file'), async (req, res) => {
  try {
    const ipfsUrl = await uploadFileToPinata(req.file);
    res.json({ ipfsUrl });
  } catch (error) {
    res.status(500).json({ error: 'Failed to upload image' });
  }
});

app.post('/upload-metadata', async (req, res) => {
  try {
    const ipfsUrl = await uploadMetadataToPinata(req.body);
    res.json({ ipfsUrl });
  } catch (error) {
    res.status(500).json({ error: 'Failed to upload metadata' });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));