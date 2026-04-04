const express = require('express');
const router = express.Router();
const Medicine = require('../models/Medicine');

// Helper to check if medicine is expired (MM/YYYY)
const isExpired = (expiryStr) => {
    try {
        if (!expiryStr) return false;
        const [month, year] = expiryStr.split('/').map(n => parseInt(n));
        const now = new Date();
        const currentMonth = now.getMonth() + 1;
        const currentYear = now.getFullYear();

        if (year < currentYear) return true;
        if (year === currentYear && month < currentMonth) return true;
        return false;
    } catch (e) {
        return false;
    }
};

// Add a new medicine
router.post('/add', async (req, res) => {
  try {
    const { name, brandName, pharmacistId, price, stockQuantity, expiryDate, pharmacistPhone } = req.body;
    
    // Check required fields
    if (!name || !price || !expiryDate || !pharmacistPhone || !pharmacistId) {
        return res.status(400).json({ message: 'Missing required fields (Name, Price, Expiry, Pharmacist Info)' });
    }

    if (price < 0 || stockQuantity < 0) {
        return res.status(400).json({ message: 'Price or Quantity cannot be negative' });
    }

    // Check if medicine already exists (Duplicate Check)
    const existing = await Medicine.findOne({ name: name, brandName: brandName, pharmacistId: pharmacistId });
    if (existing) {
        return res.status(409).json({ 
            message: 'Medicine already exists in your inventory. Update stock instead?', 
            medicine: existing 
        });
    }

    const newMedicine = new Medicine(req.body);
    await newMedicine.save();
    res.status(201).json({ message: 'Medicine added successfully', medicine: newMedicine });
  } catch (error) {
    res.status(500).json({ message: 'Error adding medicine', error: error.message });
  }
});

// Get all medicines (FOR PATIENTS - Hides Expired)
router.get('/all', async (req, res) => {
  try {
    const medicinesData = await Medicine.find().sort({ createdAt: -1 });
    // Filter out expired ones for patient side visibility
    const filtered = medicinesData.filter(m => !isExpired(m.expiryDate));
    res.status(200).json(filtered);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching medicines', error: error.message });
  }
});

// Search medicines by name (Patient Side)
router.get('/search/:name', async (req, res) => {
  try {
    const query = req.params.name;
    const medicines = await Medicine.find({ 
        $or: [
            { name: { $regex: query, $options: 'i' } },
            { genericName: { $regex: query, $options: 'i' } },
            { brandName: { $regex: query, $options: 'i' } }
        ]
    });
    // Still filter expired
    const filtered = medicines.filter(m => !isExpired(m.expiryDate));
    res.status(200).json(filtered);
  } catch (error) {
    res.status(500).json({ message: 'Error searching medicines', error: error.message });
  }
});

// Get ALL medicines for a Pharmacist (including expired, for management)
router.get('/pharmacist/:pharmacistId', async (req, res) => {
    try {
        const medicines = await Medicine.find({ pharmacistId: req.params.pharmacistId }).sort({ createdAt: -1 });
        res.status(200).json(medicines);
    } catch (e) {
        res.status(500).json({ message: 'Error fetching pharmacist inventory', error: e.message });
    }
});

// Update medicine (Pharmacist Side)
router.put('/update/:id', async (req, res) => {
  try {
    // Validations again
    if (req.body.price !== undefined && req.body.price < 0) return res.status(400).json({ message: 'Price cannot be negative' });
    if (req.body.stockQuantity !== undefined && req.body.stockQuantity < 0) return res.status(400).json({ message: 'Quantity cannot be negative' });

    const updatedMedicine = await Medicine.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedMedicine) return res.status(404).json({ message: 'Medicine not found' });
    res.status(200).json({ message: 'Medicine updated successfully', medicine: updatedMedicine });
  } catch (error) {
    res.status(500).json({ message: 'Error updating medicine', error: error.message });
  }
});

// Delete medicine
router.delete('/delete/:id', async (req, res) => {
  try {
    const deletedMedicine = await Medicine.findByIdAndDelete(req.params.id);
    if (!deletedMedicine) return res.status(404).json({ message: 'Medicine not found' });
    res.status(200).json({ message: 'Medicine deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting medicine', error: error.message });
  }
});

module.exports = router;
