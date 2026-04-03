const mongoose = require('mongoose');
const UserSchema = new mongoose.Schema({
  phone: { type: String, unique: true, sparse: true }, // For Phone Auth and Contact
  uid: { type: String, unique: true, sparse: true },   // For Health ID / Aadhar (12 digits)
  mciNumber: { type: String, unique: true, sparse: true }, // For Doctor MCI Registration Number
  ashaId: { type: String, unique: true, sparse: true },   // For ASHA Registration Number
  panchayatId: { type: String, unique: true, sparse: true }, // For Panchayat Registration Number
  googleId: { type: String, unique: true, sparse: true }, // For Google Auth
  email: { type: String, unique: true, sparse: true },
  password: { type: String }, // Hashed password
  name: { type: String, default: "User" },
  picture: { type: String },
  location: { type: String }, // General location field (already exists)
  village: { type: String },   // New field: Specific Village
  block: { type: String },     // New field: Specific Block
  hospitalName: { type: String }, // For Doctor's hospital
  age: { type: String },      // Added missing field
  emergencyContact: { type: String }, // Added missing field
  gender: { type: String, enum: ['Male', 'Female', 'Other', 'Attack Helicopter', 'Croissant'] },
  role: { type: String, enum: ['patient', 'doctor', 'admin', 'asha', 'panchayat'], default: 'patient' },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('User', UserSchema);