const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Consultation = require('../models/Consultation');
const Medicine = require('../models/Medicine');

// GET /api/stats/village?village=X&block=Y
router.get('/village', async (req, res) => {
    try {
        const { village, block } = req.query;

        if (!village) {
            return res.status(400).json({ success: false, message: 'Village name is required' });
        }

        const totalPatients = await User.countDocuments({ role: 'patient', 'location.village': village });
        const activeCases = await Consultation.countDocuments({ status: 'pending', village: village });
        const totalDoctors = await User.countDocuments({ role: 'doctor', $or: [{ 'location.village': village }, { 'location.block': block }] });
        const totalAshaWorkers = await User.countDocuments({ role: 'asha', $or: [{ 'location.village': village }, { 'location.block': block }] });

        res.status(200).json({ success: true, totalPatients, activeCases, totalDoctors, totalAshaWorkers });
    } catch (error) {
        console.error('Village Stats Error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

// GET /api/stats/asha?ashaId=X&village=Y
router.get('/asha', async (req, res) => {
    try {
        const { ashaId, village } = req.query;
        if (!ashaId || !village) return res.status(400).json({ success: false, message: 'ashaId and village are required' });
        const villagePatients = await User.countDocuments({ role: 'patient', 'location.village': village });
        const bookedConsultations = await Consultation.countDocuments({ bookedById: ashaId });
        res.status(200).json({ success: true, villagePatients, bookedConsultations });
    } catch (error) {
        console.error('ASHA Stats Error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

// GET /api/stats/pharmacist?pharmacistId=X
router.get('/pharmacist', async (req, res) => {
    try {
        const { pharmacistId } = req.query;
        if (!pharmacistId) return res.status(400).json({ success: false, message: 'pharmacistId is required' });

        const totalMedicines = await Medicine.countDocuments({ pharmacistId });
        const lowStock = await Medicine.countDocuments({ pharmacistId, stockQuantity: { $gt: 0, $lt: 10 } });
        const outOfStock = await Medicine.countDocuments({ pharmacistId, stockQuantity: 0 });
        
        // Expiry warnings (simple mock for now, checking items expiring in same year/month logic)
        // For MM/YYYY strings, logic is harder in Mongo unless we use aggregation
        // We'll leave it to frontend for details or simplify here.

        res.status(200).json({
            success: true,
            totalMedicines,
            lowStock,
            outOfStock,
        });
    } catch (error) {
        console.error('Pharmacist Stats Error:', error);
        res.status(500).json({ success: false, message: 'Server error' });
    }
});

module.exports = router;
