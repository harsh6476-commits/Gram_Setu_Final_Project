require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const User = require('./models/User'); 
const apiRoutes = require('./routes/index');

const app = express();

// 1. Connect to MongoDB
connectDB();

// Middlewares
app.use(cors());
app.use(express.json());

// Request logger middleware
app.use((req, res, next) => {
    console.log(`[${new Date().toLocaleTimeString()}] ${req.method} ${req.originalUrl}`);
    next();
});

// Load Config from .env
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'gram_setu_secret_key_123!';
// 2. Main API Routes
app.use('/api', apiRoutes); // This will handle /api/auth

// 3. Application Routes (Legacy, can be moved to index.js later)
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/triage', require('./routes/triageRoutes'));

// Hello World Route for testing
app.get('/', (req, res) => res.send('Gram Setu Backend is Running!'));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://0.0.0.0:${PORT}`);
});