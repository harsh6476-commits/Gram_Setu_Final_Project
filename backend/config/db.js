const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        const uri = process.env.MONGO_URI || 'mongodb+srv://opg7386_db_user:tmZTuN7LUxxYGgbP@cluster0.h8hfawa.mongodb.net/gram_setu?retryWrites=true&w=majority';
<<<<<<< HEAD
        const conn = await mongoose.connect(uri, {
            serverSelectionTimeoutMS: 5000 // Error out faster instead of hanging
=======
        // Add a 5s timeout to avoid long hangs
        const conn = await mongoose.connect(uri, {
            serverSelectionTimeoutMS: 5000
>>>>>>> c5d64c7013d732133b3ffd9d5ee7d327c45f8fc6
        });
        console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.error(`❌ MongoDB Connection Error: ${error.message}`);
        console.log('\n--- Troubleshooting MongoDB Atlas Connection ---');
<<<<<<< HEAD
        console.log('1. Check if your current IP is whitelisted in Atlas (0.0.0.0/0 is recommended for testing).');
        console.log('2. Check if your network blocks outbound connection on port 27017 (Common in university/office Wi-Fi).');
        console.log('3. Solution: Use a mobile hotspot or a VPN.');
        console.log('4. Ensure your MONGO_URI in .env is correct and has no extra spaces.\n');
        // process.exit(1); // REMOVED: Keep server running so you can see descriptive errors
=======
        console.log(`1. Your current IP: 117.250.157.213 (Make sure this is whitelisted in Atlas)`);
        console.log('2. Network restriction: Your network (iiitm.ac.in) might be blocking port 27017.');
        console.log('3. Recommendation: Use a Mobile Hotspot / VPN or whitelist 0.0.0.0/0 on the Atlas Dashboard.');
        console.log('4. The server will keep running, but DB-dependent features will fail.\n');
        // Do NOT call process.exit(1) so the app stays alive
>>>>>>> c5d64c7013d732133b3ffd9d5ee7d327c45f8fc6
    }
};

module.exports = connectDB;
