import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/user_provider.dart';
import '../services/api_service.dart';
import '../services/medicine_service.dart';
import '../core/models/medicine_request.dart';
import '../widgets/gram_app_bar.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_card.dart';
import '../widgets/translated_text.dart';
import 'vitals_history_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _currentIndex = 0;
  int _consultationCount = 0;
  int _prescriptionCount = 0;
  List<MedicineRequest> _medicineRequests = [];
  bool _isLoadingRequests = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchMedicineRequests();
  }

  Future<void> _fetchDashboardData() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return;
    
    try {
      final uid = user['uid'];
      final response = await ApiService.get('/users/uid/$uid');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _consultationCount = (data['consultations'] as List?)?.length ?? 0;
            _prescriptionCount = (data['prescriptions'] as List?)?.length ?? 0;
          });
        }
      }
    } catch (e) {
      print('Dashboard Data Error: $e');
    }
  }

  Future<void> _fetchMedicineRequests() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null || user['uid'] == null) return;
    
    final requests = await MedicineService.getPatientRequests(user['uid']);
    if (mounted) {
      setState(() {
        _medicineRequests = requests;
        _isLoadingRequests = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final userName = user?['name'] ?? 'User';
    final uid = user?['uid'] ?? 'N/A';

    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: GramAppBar(
        roleLabel: 'Patient Dashboard',
        onLogoutTap: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchDashboardData();
            await _fetchMedicineRequests();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(userName, uid),
                const SizedBox(height: 24),
                _buildStats(),
                const SizedBox(height: 32),
                _buildQuickActions(uid),
                const SizedBox(height: 32),
                _buildMedicineRequestsSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildGreeting(String name, String uid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText(
              'Hello, ${name.split(' ').first} 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context)),
            ),
            const SizedBox(height: 4),
            TranslatedText('How are you feeling today?', style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.adaptiveSurface(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.adaptiveBorder(context).withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TranslatedText('Your UID', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(uid, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Prescriptions',
            value: '$_prescriptionCount Rx',
            icon: Icons.medication_outlined,
            bgColor: Colors.teal,
            textColor: Colors.white,
            iconColor: Colors.white,
            iconBgColor: Colors.white.withOpacity(0.2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Consultations',
            value: '$_consultationCount Done',
            icon: Icons.calendar_month_outlined,
            bgColor: Colors.orange,
            textColor: Colors.white,
            iconColor: Colors.white,
            iconBgColor: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 16),
        ActionCard(
          title: 'Buy Medicines',
          subtitle: 'Search and request drugs',
          icon: Icons.shopping_basket_outlined,
          isDark: true,
          accentColor: AppColors.primaryTeal,
          onTap: () => Navigator.pushNamed(context, '/medicine_buy'),
        ),
        ActionCard(
          title: 'Book Consultation',
          subtitle: 'Talk to a doctor now',
          icon: Icons.add_box_outlined,
          isDark: true,
          accentColor: AppColors.primaryTeal,
          onTap: () => Navigator.pushNamed(context, '/consultation'),
        ),
        ActionCard(
          title: 'Heart Rate Scan (rPPG)',
          subtitle: 'Measure vitals using phone camera',
          icon: Icons.favorite_border,
          isDark: true,
          accentColor: Colors.redAccent,
          onTap: () => Navigator.pushNamed(context, '/rppg_monitor', arguments: uid),
        ),
      ],
    );
  }

  Widget _buildMedicineRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TranslatedText('Medicine Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
            if (!_isLoadingRequests)
              IconButton(onPressed: _fetchMedicineRequests, icon: const Icon(Icons.refresh, size: 20, color: AppColors.primaryTeal)),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoadingRequests)
          const Center(child: CircularProgressIndicator())
        else if (_medicineRequests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.adaptiveSurface(context), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.adaptiveBorder(context))),
            child: const Column(
              children: [
                Icon(Icons.shopping_cart_outlined, color: Colors.grey, size: 40),
                SizedBox(height: 12),
                TranslatedText('No medicine requests found.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _medicineRequests.length > 3 ? 3 : _medicineRequests.length, // Show recent 3
            itemBuilder: (context, index) => _buildRequestCard(_medicineRequests[index]),
          ),
      ],
    );
  }

  Widget _buildRequestCard(MedicineRequest request) {
    Color statusColor = Colors.grey;
    if (request.requestStatus == 'Pending') statusColor = Colors.yellow[800]!;
    if (request.requestStatus == 'Approved') statusColor = Colors.green;
    if (request.requestStatus == 'Rejected') statusColor = Colors.red;
    if (request.requestStatus.contains('Delivery') || request.requestStatus.contains('Pickup')) statusColor = Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.adaptiveSurface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.adaptiveBorder(context).withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.medicineName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildStatusBadge(request.requestStatus, statusColor),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              TranslatedText('Quantity: ${request.quantityRequested}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Text(_formatDate(request.createdAt), style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const Divider(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
               onPressed: () => _viewRequestStatus(request),
               style: OutlinedButton.styleFrom(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                 side: BorderSide(color: statusColor.withOpacity(0.5)),
               ),
               child: TranslatedText('View Status', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _viewRequestStatus(MedicineRequest request) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(request.medicineName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                _buildStatusBadge(request.requestStatus, Colors.blue),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const TranslatedText('Order Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TranslatedText(request.requestStatus),
              ],
            ),
            const SizedBox(height: 8),
            if (request.pharmacistResponse != null && request.pharmacistResponse!.isNotEmpty) ...[
              const TranslatedText('Pharmacist Note:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request.pharmacistResponse!, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
            ],
            if (request.requestStatus == 'Approved' || request.requestStatus == 'Ready for Pickup')
              const TranslatedText('Please visit the pharmacy for pickup or wait for delivery updates.', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.w500)),
            if (request.requestStatus == 'Out for Delivery')
              const TranslatedText('The delivery agent is on the way to your location.', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () => Navigator.pop(context), 
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const TranslatedText('Close', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.adaptiveSurface(context).withAlpha(229),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.adaptiveBorder(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Dashboard', 0),
          _buildNavItem(Icons.person_outline, 'Profile', 1),
          _buildNavItem(Icons.settings_outlined, 'Settings', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          setState(() => _currentIndex = index);
          return;
        }
        if (index == 1) await Navigator.pushNamed(context, '/profile', arguments: 'patient');
        else if (index == 2) await Navigator.pushNamed(context, '/settings');
        if (mounted) setState(() => _currentIndex = 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: isSelected ? BoxDecoration(color: AppColors.primaryTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(30)) : null,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryTeal : Colors.grey, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              TranslatedText(label, style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}
