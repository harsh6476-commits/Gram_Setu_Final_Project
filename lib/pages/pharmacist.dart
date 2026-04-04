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
import '../widgets/pharmacist/requests_tab.dart';
import '../widgets/pharmacist/notifications_tab.dart';
import '../widgets/pharmacist/pharmacist_profile_tab.dart';
import '../widgets/translated_text.dart';

class PharmacistDashboard extends StatefulWidget {
  const PharmacistDashboard({super.key});

  @override
  State<PharmacistDashboard> createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _stats = {};
  bool _isLoadingStats = true;
  int _prevPendingCount = -1;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchStats();
    // Refresh stats every 30 seconds for alerts
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) => _fetchStats(isPolling: true));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchStats({bool isPolling = false}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    if (pharmacistId.isEmpty) return;

    final stats = await MedicineService.getPharmacistStats(pharmacistId);
    if (!mounted) return;

    final currentPending = stats['pendingRequests'] ?? 0;
    
    // Alert logic
    if (isPolling && _prevPendingCount != -1 && currentPending > _prevPendingCount) {
      _showNewRequestPopup();
    }
    
    setState(() {
      _stats = stats;
      _isLoadingStats = false;
      _prevPendingCount = currentPending;
    });
  }

  void _showNewRequestPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notification_important, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(child: TranslatedText('New medicine request received!', style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton(
              onPressed: () {
                _tabController.animateTo(2); // Go to Requests Tab
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const TranslatedText('VIEW', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryTeal,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
            isScrollable: true,
            tabs: [
              const Tab(text: 'Inventory'),
              const Tab(text: 'Add Med'),
              _buildBadgeTab('Requests', _stats['pendingRequests'] ?? 0),
              const Tab(text: 'Alerts'),
              const Tab(text: 'Profile'),
            ],
            labelColor: AppColors.primaryTeal,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryTeal,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const InventoryTab(),
                const AddMedicineTab(),
                const RequestsTab(),
                const NotificationsTab(),
                const PharmacistProfileTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TranslatedText(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
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
          const SizedBox(width: 12),
          _buildStatCard('Pending', 'pendingRequests', Icons.pending_actions, Colors.teal),
          const SizedBox(width: 12),
          _buildStatCard('Completed', 'completedOrders', Icons.check_circle_outline, Colors.green),
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
