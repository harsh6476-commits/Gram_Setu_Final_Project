const express = require('express');
const router = express.Router();
const TriageCase = require('../models/TriageCase');
const authMiddleware = require('../middleware/authMiddleware');

// @route   POST /api/triage
// @desc    Create a new triage case
// @access  Private (Authenticated)
router.post('/', authMiddleware, async (req, res) => {
    const { name, village, symptoms, severity } = req.body;

    try {
        const newCase = new TriageCase({
            patientId: req.user.userId,
            name,
            village,
            symptoms,
            severity: severity || 'Mild',
            status: 'Pending'
        });

        const savedCase = await newCase.save();
        res.status(201).json(savedCase);
    } catch (error) {
        console.error('Error creating triage case:', error.message);
        res.status(500).json({ message: 'Server error' });
    }
});

// @route   GET /api/triage
// @desc    Get all triage cases for the logged-in user (patients) or all cases (doctors/asha)
// @access  Private (Authenticated)
router.get('/', authMiddleware, async (req, res) => {
    try {
        let cases;
        if (req.user.role === 'patient') {
            cases = await TriageCase.find({ patientId: req.user.userId });
        } else {
            // For workers/doctors, fetch all cases
            cases = await TriageCase.find().sort({ createdAt: -1 });
        }
        res.status(200).json(cases);
    } catch (error) {
        console.error('Error fetching triage cases:', error.message);
        res.status(500).json({ message: 'Server error' });
    }
});

module.exports = router;
