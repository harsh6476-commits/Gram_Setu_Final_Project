const express = require('express');
const router = express.Router();

// Import Routes
const authRoutes = require('./authRoutes');

// Use Routes
router.use('/auth', authRoutes);

// Optional: Test Route
router.get('/health', (req, res) => res.status(200).json({ status: 'ok', API_Version: '1.0' }));

module.exports = router;
