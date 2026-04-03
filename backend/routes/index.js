const express = require('express');
const router = express.Router();

// Import Routes
const authRoutes = require('./authRoutes');
const consultationRoutes = require('./consultationRoutes');
const userRoutes = require('./userRoutes');
const triageRoutes = require('./triageRoutes');

// Use Routes
router.use('/auth', authRoutes);
router.use('/consultations', consultationRoutes);
router.use('/users', userRoutes);
router.use('/triage', triageRoutes);

// Optional: Test Route
router.get('/health', (req, res) => res.status(200).json({ status: 'ok', API_Version: '1.0' }));

module.exports = router;
