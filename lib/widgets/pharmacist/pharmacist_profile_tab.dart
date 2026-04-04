import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/user_provider.dart';
import '../../widgets/translated_text.dart';

class PharmacistProfileTab extends StatelessWidget {
  const PharmacistProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
            child: const Icon(Icons.person, size: 50, color: AppColors.primaryTeal),
          ),
          const SizedBox(height: 16),
          Text(user?['name'] ?? 'Pharmacist', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user?['role']?.toString().toUpperCase() ?? 'PHARMACIST', style: const TextStyle(fontSize: 13, color: Colors.grey, letterSpacing: 1.2)),
          
          const SizedBox(height: 32),
          
          _buildInfoTile(context, 'Name', user?['name'] ?? 'N/A', Icons.person_outline),
          _buildInfoTile(context, 'Pharmacist ID', user?['pharmacistId'] ?? 'N/A', Icons.badge_outlined),
          _buildInfoTile(context, 'Contact', user?['phone'] ?? 'N/A', Icons.phone_outlined),
          _buildInfoTile(context, 'Store Location', user?['location']?['fullLocation'] ?? 'N/A', Icons.store_outlined),
          _buildInfoTile(context, 'Joined On', user?['createdAt']?.toString().substring(0, 10) ?? 'N/A', Icons.calendar_today_outlined),
          
          const SizedBox(height: 48),
          
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
               onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
               icon: const Icon(Icons.logout),
               label: const TranslatedText('Sign Out Safely'),
               style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.adaptiveBorder(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryTeal, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
