import 'package:flutter/material.dart';
import 'login.dart'; // We will create this file next

class GramSetuHomePage extends StatelessWidget {
  const GramSetuHomePage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color(0xFFBCE3DD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderIconButton(Icons.light_mode),
                      const SizedBox(width: 12),
                      _buildHeaderIconButton(Icons.health_and_safety),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),

              // Grid Section
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  // Clickable Patient Card
                  _buildNavCard(
                    context: context,
                    title: 'Patient',
                    subtitle: 'Health & Consultations',
                    iconData: Icons.person,
                    iconColor: Colors.blueAccent,
                    iconBgColor: Colors.blue.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatientLoginPage(),
                        ),
                      );
                    },
                  ),
                  _buildNavCard(
                    context: context,
                    title: 'ASHA Worker',
                    subtitle: 'Community Health',
                    iconData: Icons.favorite,
                    iconColor: Colors.pinkAccent,
                    iconBgColor: Colors.pink.shade50,
                  ),
                  _buildNavCard(
                    context: context,
                    title: 'Doctor',
                    subtitle: 'Virtual Clinic',
                    iconData: Icons.medical_services,
                    iconColor: Colors.teal.shade500,
                    iconBgColor: Colors.teal.shade50,
                  ),
                  _buildNavCard(
                    context: context,
                    title: 'Panchayat',
                    subtitle: 'Administration',
                    iconData: Icons.account_balance,
                    iconColor: Colors.deepPurpleAccent,
                    iconBgColor: Colors.deepPurple.shade50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                  child: Icon(iconData, color: iconColor, size: 28),
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
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.teal.shade700, size: 24),
    );
  }
}