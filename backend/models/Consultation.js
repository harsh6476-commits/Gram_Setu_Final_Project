const mongoose = require('mongoose');

const ConsultationSchema = new mongoose.Schema({
    uid: { type: String, required: true }, // The patient's Health ID / UID (Aadhar-like)
    problem: { type: String, required: true }, // Description of the symptoms or problem
    patientName: { type: String }, // For convenience (optional)
    status: { 
        type: String, 
        enum: ['pending', 'completed', 'canceled'], 
        default: 'pending' 
    },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Consultation', ConsultationSchema);
