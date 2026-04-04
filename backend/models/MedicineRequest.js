const mongoose = require('mongoose');

const MedicineRequestSchema = new mongoose.Schema({
  patientName: { type: String, required: true },
  phone: { type: String, required: true },
  location: { type: String },
  address: { type: String },
  medicineId: { type: mongoose.Schema.Types.ObjectId, ref: 'Medicine', required: true },
  quantity: { type: Number, default: 1 },
  notes: { type: String },
  status: { 
    type: String, 
    enum: ['Pending', 'Accepted', 'Rejected', 'Out for Delivery', 'Delivered', 'Cancelled'], 
    default: 'Pending' 
  },
  prescriptionUrl: { type: String }, 
  pharmacistId: { type: String }, 
  rejectionReason: { type: String },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('MedicineRequest', MedicineRequestSchema);
