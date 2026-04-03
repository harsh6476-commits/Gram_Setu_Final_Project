import 'package:flutter/material.dart';

void main() {
  runApp(const GramSetuApp());
}

class GramSetuApp extends StatelessWidget {
  const GramSetuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gram Setu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // You can replace this with your preferred font
      ),
      home: const GramSetuHomePage(),
    );
  }
}

class GramSetuHomePage extends StatelessWidget {
  const GramSetuHomePage({Key? key}) : super(key: key);

  // Define the background color to match the design
  final Color backgroundColor = const Color(0xFFBCE3DD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gram Setu',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Healthcare & Rural Network',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderIconButton(Icons.light_mode, Colors.teal.shade700),
                      const SizedBox(width: 12),
                      _buildHeaderIconButton(Icons.health_and_safety, Colors.teal.shade700),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),

              // Grid Section
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82, // Adjusts the height-to-width ratio of cards
                  children: [
                    _buildDashboardCard(
                      title: 'Patient',
                      subtitle: 'Health & Consultations',
                      iconData: Icons.person,
                      iconColor: Colors.blueAccent,
                      iconBgColor: Colors.blue.shade50,
                    ),
                    _buildDashboardCard(
                      title: 'ASHA Worker',
                      subtitle: 'Community Health',
                      iconData: Icons.favorite,
                      iconColor: Colors.pinkAccent,
                      iconBgColor: Colors.pink.shade50,
                    ),
                    _buildDashboardCard(
                      title: 'Doctor',
                      subtitle: 'Virtual Clinic',
                      iconData: Icons.medical_services,
                      iconColor: Colors.teal.shade500,
                      iconBgColor: Colors.teal.shade50,
                    ),
                    _buildDashboardCard(
                      title: 'Panchayat',
                      subtitle: 'Village Administration',
                      iconData: Icons.account_balance,
                      iconColor: Colors.deepPurpleAccent,
                      iconBgColor: Colors.deepPurple.shade50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the top-right circular buttons
  Widget _buildHeaderIconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  // Helper widget for the main grid cards
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 28,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}