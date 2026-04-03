const express = require('express');
const router = express.Router();
const Consultation = require('../models/Consultation');
const User = require('../models/User');

// @route   POST /api/consultations/request
// @desc    Request a new consultation
// @access  Private/Public (depending on your logic)
router.post('/request', async (req, res) => {
    const { uid, problem } = req.body;

    if (!uid || !problem) {
        return res.status(400).json({ success: false, message: 'UID and problem are required' });
    }

    try {
        // Optional: Look up patient name if UID exists in User collection
        const user = await User.findOne({ uid });
        const patientName = user ? user.name : 'Unknown';

        const consultation = new Consultation({
            uid,
            problem,
            patientName
        });

        await consultation.save();
        res.status(201).json({ success: true, consultation });
    } catch (error) {
        console.error('Consultation creation error:', error.message);
        res.status(500).json({ success: false, message: 'Server error creating consultation' });
    }
});

// @route   GET /api/consultations/pending
// @desc    Get all pending consultations (for Doctor)
// @access  Private/Public
router.get('/pending', async (req, res) => {
    try {
        const pending = await Consultation.find({ status: 'pending' }).sort({ createdAt: -1 });
        res.status(200).json({ success: true, consultations: pending });
    } catch (error) {
        console.error('Fetch pending consultations error:', error.message);
        res.status(500).json({ success: false, message: 'Server error fetching pending consultations' });
    }
});

// @route   GET /api/consultations/user/:uid
// @desc    Get all consultation records for a specific UID (for Panchayat)
// @access  Private/Public
router.get('/user/:uid', async (req, res) => {
    const { uid } = req.params;
    try {
        const records = await Consultation.find({ uid }).sort({ createdAt: -1 });
        res.status(200).json({ success: true, records });
    } catch (error) {
        console.error('Fetch user history error:', error.message);
        res.status(500).json({ success: false, message: 'Server error fetching user history' });
    }
});

// @route   PATCH /api/consultations/:id/complete
// @desc    Complete a consultation (mark as completed)
router.patch('/:id/complete', async (req, res) => {
    try {
        const consultation = await Consultation.findByIdAndUpdate(
            req.params.id, 
            { status: 'completed' },
            { new: true }
        );
        res.status(200).json({ success: true, consultation });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Error marking completed' });
    }
});

module.exports = router;
