const express = require('express');
const router = express.Router();
const Medicine = require('../models/Medicine');
const MedicineRequest = require('../models/MedicineRequest');

// Add a new medicine
router.post('/add', async (req, res) => {
  try {
    const { name, genericName, brandName, category, expiryDate, availability, price, stockQuantity, description, manufacturer, prescriptionRequired, imageUrl, pharmacistId } = req.body;
    
    const existing = await Medicine.findOne({ name: name, brandName: brandName });
    if (existing) {
        return res.status(449).json({ message: 'Medicine already exists', medicine: existing });
    }

    const newMedicine = new Medicine({
      name, genericName, brandName, category, 
      expiryDate, 
      availability: availability !== undefined ? availability : true, 
      price, stockQuantity,
      description, manufacturer, prescriptionRequired, imageUrl,
      pharmacistId
    });
    await newMedicine.save();
    res.status(201).json({ message: 'Medicine added successfully', medicine: newMedicine });
  } catch (error) {
    res.status(500).json({ message: 'Error adding medicine', error: error.message });
  }
});

// Get all medicines
router.get('/all', async (req, res) => {
  try {
    const medicines = await Medicine.find().sort({ createdAt: -1 });
    res.status(200).json(medicines);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching medicines', error: error.message });
  }
});

// Search medicines by name
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
    res.status(200).json(medicines);
  } catch (error) {
    res.status(500).json({ message: 'Error searching medicines', error: error.message });
  }
});

// Update medicine
router.put('/update/:id', async (req, res) => {
  try {
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

// --- Medicine Requests ---

// Submit a new medicine request
router.post('/request', async (req, res) => {
    try {
        const { patientUID, patientName, patientPhone, medicineId, medicineName, quantityRequested, prescriptionUrl, optionalNote } = req.body;
        
        if (!patientUID || !medicineId || !medicineName) {
            return res.status(400).json({ message: 'Required fields missing' });
        }

        const newRequest = new MedicineRequest({
            patientUID, patientName, patientPhone,
            medicineId, medicineName,
            quantityRequested, prescriptionUrl, optionalNote
        });
        
        await newRequest.save();
        res.status(201).json({ message: 'Medicine request submitted successfully', request: newRequest });
    } catch (e) {
        res.status(500).json({ message: 'Error requesting medicine', error: e.message });
    }
});

// Get requests for a specific patient
router.get('/requests/patient/:uid', async (req, res) => {
    try {
        const requests = await MedicineRequest.find({ patientUID: req.params.uid }).sort({ createdAt: -1 });
        res.status(200).json(requests);
    } catch (e) {
        res.status(500).json({ message: 'Error fetching patient medicine requests', error: e.message });
    }
});

// Get all requests (Pharmacist Side)
router.get('/requests', async (req, res) => {
    try {
        const { pharmacistId, requestStatus } = req.query;
        let filter = {};
        if (pharmacistId) filter.pharmacistId = pharmacistId;
        if (requestStatus) filter.requestStatus = requestStatus;

        const requests = await MedicineRequest.find(filter).sort({ createdAt: -1 });
        res.status(200).json(requests);
    } catch (e) {
        res.status(500).json({ message: 'Error fetching medicine requests', error: e.message });
    }
});

// Update request status (Pharmacist Side)
router.put('/request/:id', async (req, res) => {
    try {
        const { requestStatus, pharmacistId, pharmacistResponse } = req.body;
        const updated = await MedicineRequest.findByIdAndUpdate(
            req.params.id, 
            { requestStatus, pharmacistId, pharmacistResponse, updatedAt: Date.now() }, 
            { new: true }
        );
        if (!updated) return res.status(404).json({ message: 'Medicine request not found' });
        res.status(200).json({ message: 'Medicine request updated', request: updated });
    } catch (e) {
        res.status(500).json({ message: 'Error updating medicine request', error: e.message });
    }
});

module.exports = router;
