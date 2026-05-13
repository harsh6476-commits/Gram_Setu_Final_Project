const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        const uri = process.env.MONGO_URI || 'mongodb+srv://harshprajapathp45_db_user:nM6StVL8uFQDefbE@cluster0.n7sd8bd.mongodb.net/gram_setu?retryWrites=true&w=majority&appName=Cluster0';
        // Add a 5s timeout to avoid long hangs
        const conn = await mongoose.connect(uri, {
            serverSelectionTimeoutMS: 5000
        });
        console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.error(`❌ MongoDB Connection Error: ${error.message}`);
        console.log('\n--- Troubleshooting MongoDB Atlas Connection ---');
        console.log(`1. Your current IP: 117.250.157.213 (Make sure this is whitelisted in Atlas)`);
        console.log('2. Network restriction: Your network (iiitm.ac.in) might be blocking port 27017.');
        console.log('3. Recommendation: Use a Mobile Hotspot / VPN or whitelist 0.0.0.0/0 on the Atlas Dashboard.');
        console.log('4. The server will keep running, but DB-dependent features will fail.\n');
        // Do NOT call process.exit(1) so the app stays alive
    }
};

module.exports = connectDB;
