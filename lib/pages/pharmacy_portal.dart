import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/translated_text.dart';

class PharmacyPortal extends StatelessWidget {
  const PharmacyPortal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const TranslatedText('Pharmacy Hub'),
        backgroundColor: theme.cardTheme.color,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const TranslatedText(
              'Welcome back!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TranslatedText(
              'Select an option to continue',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            
            _buildOptionCard(
              context: context,
              title: 'Buy Medicines',
              subtitle: 'Browse & request medical supplies',
              icon: Icons.shopping_basket_outlined,
              color: AppColors.primaryTeal,
              onTap: () => Navigator.pushNamed(context, '/buy_medicines'),
            ),
            
            const SizedBox(height: 24),
            
            _buildOptionCard(
              context: context,
              title: 'Pharmacist Login',
              subtitle: 'Access inventory & manage requests',
              icon: Icons.admin_panel_settings_outlined,
              color: AppColors.softPurple,
              onTap: () => Navigator.pushNamed(context, '/pharmacist_auth'),
            ),
            
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/images/pharmacy_illustration.png', // Temporary, if exists
                height: 180,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medication_liquid_outlined,
                  size: 100,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TranslatedText(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
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
