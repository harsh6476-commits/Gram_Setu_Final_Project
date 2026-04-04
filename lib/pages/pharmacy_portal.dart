import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/user_provider.dart';
import '../widgets/gram_app_bar.dart';
import '../widgets/translated_text.dart';

class PharmacyPortal extends StatelessWidget {
  const PharmacyPortal({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isAuthenticated = userProvider.user != null && userProvider.role == 'patient';

    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: GramAppBar(
        roleLabel: 'Gram Pharmacy',
        showProfile: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_pharmacy_outlined, size: 80, color: AppColors.primaryTeal),
              const SizedBox(height: 24),
              const TranslatedText(
                'Welcome to Village Pharmacy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const TranslatedText(
                'Access essential medicines easily',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildOptionCard(
                context,
                title: 'Buy Medicines',
                subtitle: 'Search and browse medicines',
                icon: Icons.shopping_basket_outlined,
                color: AppColors.primaryTeal,
                onTap: () {
                   if (isAuthenticated) {
                     Navigator.pushNamed(context, '/medicine_buy');
                   } else {
                     // Force login
                     Navigator.pushNamed(context, '/login', arguments: {'redirectTo': '/medicine_buy'});
                   }
                },
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                title: 'Pharmacist Login',
                subtitle: 'Manage stock and inventory',
                icon: Icons.admin_panel_settings_outlined,
                color: Colors.blueGrey,
                onTap: () => Navigator.pushNamed(context, '/pharmacist_auth'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.adaptiveBorder(context).withOpacity(0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  TranslatedText(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
