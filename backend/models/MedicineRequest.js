const mongoose = require('mongoose');

const MedicineRequestSchema = new mongoose.Schema({
  patientUID: { type: String, required: true },
  patientName: { type: String, required: true },
  patientPhone: { type: String, required: true },
  medicineId: { type: mongoose.Schema.Types.ObjectId, ref: 'Medicine', required: true },
  medicineName: { type: String, required: true }, // Store name directly for easy retrieval
  quantityRequested: { type: Number, default: 1 },
  prescriptionUrl: { type: String },
  optionalNote: { type: String },
  requestStatus: { 
    type: String, 
    enum: ['Pending', 'Approved', 'Rejected', 'Ready for Pickup', 'Out for Delivery', 'Delivered'], 
    default: 'Pending' 
  },
  pharmacistId: { type: String }, // Assign to the pharmacist who approved/is handling
  pharmacistResponse: { type: String }, // Note if rejected or other info
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model('MedicineRequest', MedicineRequestSchema);
