const mongoose = require('mongoose');

const TriageCaseSchema = new mongoose.Schema({
  patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true }, // Duplicate for display speed
  village: { type: String, required: true },
  symptoms: { type: String, required: true },
  severity: { 
    type: String, 
    enum: ['Mild', 'Moderate', 'Emergency', 'Escalated'], 
    default: 'Mild' 
  },
  status: { 
    type: String, 
    enum: ['Pending', 'Waiting for Doctor', 'Prescription Ready', 'Closed'], 
    default: 'Pending' 
  },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('TriageCase', TriageCaseSchema);
