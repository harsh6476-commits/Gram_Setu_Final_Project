import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/user_provider.dart';
import '../services/medicine_service.dart';
import '../widgets/gram_app_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/pharmacist/inventory_tab.dart';
import '../widgets/pharmacist/add_medicine_tab.dart';
import '../widgets/pharmacist/requests_tab.dart';
import '../widgets/pharmacist/notifications_tab.dart';
import '../widgets/pharmacist/pharmacist_profile_tab.dart';

class PharmacistDashboard extends StatefulWidget {
  const PharmacistDashboard({super.key});

  @override
  State<PharmacistDashboard> createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> {
  Map<String, dynamic> _stats = {};
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final stats = await MedicineService.getPharmacistStats(user?['pharmacistId'] ?? '');
    if (mounted) setState(() { _stats = stats; _isLoadingStats = false; });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.adaptiveBackground(context),
        appBar: GramAppBar(
          roleLabel: 'Pharmacist Portal',
          onLogoutTap: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        body: Column(
          children: [
            _buildStatsSection(),
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Inventory'),
                Tab(text: 'Add Med'),
                Tab(text: 'Requests'),
                Tab(text: 'Alerts'),
                Tab(text: 'Profile'),
              ],
              labelColor: AppColors.primaryTeal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryTeal,
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  InventoryTab(),
                  AddMedicineTab(),
                  RequestsTab(),
                  NotificationsTab(),
                  PharmacistProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    if (_isLoadingStats) return const LinearProgressIndicator(minHeight: 2);
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(width: 160, child: StatCard(title: 'Total Meds', value: _stats['totalMedicines']?.toString() ?? '0', icon: Icons.medication, bgColor: Colors.blue, textColor: Colors.white, iconColor: Colors.white)),
          const SizedBox(width: 12),
          SizedBox(width: 160, child: StatCard(title: 'Low Stock', value: _stats['lowStock']?.toString() ?? '0', icon: Icons.warning_amber, bgColor: Colors.orange, textColor: Colors.white, iconColor: Colors.white)),
          const SizedBox(width: 12),
          SizedBox(width: 160, child: StatCard(title: 'Out Stock', value: _stats['outOfStock']?.toString() ?? '0', icon: Icons.error_outline, bgColor: Colors.red, textColor: Colors.white, iconColor: Colors.white)),
          const SizedBox(width: 12),
          SizedBox(width: 160, child: StatCard(title: 'Pending', value: _stats['pendingRequests']?.toString() ?? '0', icon: Icons.pending_actions, bgColor: Colors.teal, textColor: Colors.white, iconColor: Colors.white)),
          const SizedBox(width: 12),
          SizedBox(width: 160, child: StatCard(title: 'Completed', value: _stats['completedOrders']?.toString() ?? '0', icon: Icons.check_circle_outline, bgColor: Colors.green, textColor: Colors.white, iconColor: Colors.white)),
        ],
      ),
    );
  }
}
