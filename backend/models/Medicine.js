const mongoose = require('mongoose');

const MedicineSchema = new mongoose.Schema({
  name: { type: String, required: true },
  genericName: { type: String },
  brandName: { type: String },
  category: { type: String, default: 'General' },
  expiryDate: { type: String, required: true }, // Format typically MM/YYYY or DD/MM/YYYY
  availability: { type: Boolean, default: true },
  price: { type: Number, required: true, min: 0 },
  stockQuantity: { type: Number, default: 0, min: 0 },
  description: { type: String },
  manufacturer: { type: String },
  prescriptionRequired: { type: Boolean, default: false },
  imageUrl: { type: String },
  pharmacistId: { type: String, required: true }, 
  pharmacistPhone: { type: String, required: true }, // For the "Call" feature
  pharmacistName: { type: String },
  shopName: { type: String },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Medicine', MedicineSchema);
