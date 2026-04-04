import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/user_provider.dart';
import '../services/medicine_service.dart';
import '../widgets/gram_app_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/pharmacist/inventory_tab.dart';
import '../widgets/pharmacist/add_medicine_tab.dart';
import '../widgets/pharmacist/notifications_tab.dart';
import '../widgets/pharmacist/pharmacist_profile_tab.dart';

class PharmacistDashboard extends StatefulWidget {
  const PharmacistDashboard({super.key});

  @override
  State<PharmacistDashboard> createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _stats = {};
  bool _isLoadingStats = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchStats();
    // Refresh stats every 60 seconds
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) => _fetchStats());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    if (pharmacistId.isEmpty) return;

    final stats = await MedicineService.getPharmacistStats(pharmacistId);
    if (!mounted) return;
    
    setState(() {
      _stats = stats;
      _isLoadingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: GramAppBar(
        roleLabel: 'Pharmacist Portal',
        onLogoutTap: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      body: Column(
        children: [
          _buildStatsSection(),
          TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(text: 'Inventory'),
              Tab(text: 'Add Med'),
              Tab(text: 'Alerts'),
              Tab(text: 'Profile'),
            ],
            labelColor: AppColors.primaryTeal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryTeal,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const InventoryTab(),
                const AddMedicineTab(),
                const NotificationsTab(),
                const PharmacistProfileTab(),
              ],
            ),
          ),
        ],
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
          _buildStatCard('Total Meds', 'totalMedicines', Icons.medication, Colors.blue),
          const SizedBox(width: 12),
          _buildStatCard('Low Stock', 'lowStock', Icons.warning_amber, Colors.orange),
          const SizedBox(width: 12),
          _buildStatCard('Out Stock', 'outOfStock', Icons.error_outline, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String key, IconData icon, Color color) {
    return SizedBox(
      width: 160,
      child: StatCard(
        title: title, 
        value: _stats[key]?.toString() ?? '0', 
        icon: icon, 
        bgColor: color,
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
    );
  }
}
