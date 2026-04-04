import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/user_provider.dart';
import '../../core/models/medicine_request.dart';
import '../../services/medicine_service.dart';
import '../../widgets/translated_text.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  bool _isLoading = true;
  List<MedicineRequest> _requests = [];
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    
    // Status filter is applied in UI for now, but service supports it
    final requests = await MedicineService.getRequests(pharmacistId: pharmacistId);
    setState(() {
      _requests = requests;
      _isLoading = false;
    });
  }

  List<MedicineRequest> get filteredRequests {
    if (_selectedStatus == 'All') return _requests;
    return _requests.where((r) => r.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusFilter(),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchRequests,
                child: filteredRequests.isEmpty
                  ? const Center(child: TranslatedText('No requests found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredRequests.length,
                      itemBuilder: (context, index) {
                        return _buildRequestCard(filteredRequests[index]);
                      },
                    ),
              ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    final statuses = ['Pending', 'Accepted', 'Rejected', 'Out for Delivery', 'Delivered', 'Cancelled', 'All'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: statuses.map((s) {
          final isSelected = _selectedStatus == s;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: TranslatedText(s, style: TextStyle(color: isSelected ? Colors.white : AppColors.adaptiveTextPrimary(context))),
              selected: isSelected,
              onSelected: (v) => setState(() => _selectedStatus = s),
              selectedColor: AppColors.primaryTeal,
              backgroundColor: AppColors.adaptiveBackground(context),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRequestCard(MedicineRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.adaptiveBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.patientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildStatusIndicator(request.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.medication, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(request.medicineName ?? 'Unknown Medicine', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text('x ${request.quantity}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(request.phone, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          if (request.status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateRequest(request.id, 'Accepted'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const TranslatedText('Accept', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRejectDialog(request.id),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                    child: const TranslatedText('Reject'),
                  ),
                ),
              ],
            )
          else if (request.status == 'Accepted')
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () => _updateRequest(request.id, 'Out for Delivery'),
                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                 child: const TranslatedText('Mark Out for Delivery', style: TextStyle(color: Colors.white)),
               ),
             )
          else if (request.status == 'Out for Delivery')
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () => _updateRequest(request.id, 'Delivered'),
                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                 child: const TranslatedText('Mark Delivered', style: TextStyle(color: Colors.white)),
               ),
             ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
     Color color = Colors.grey;
     if (status == 'Pending') color = Colors.orange;
     if (status == 'Accepted') color = Colors.green;
     if (status == 'Rejected') color = Colors.red;
     if (status == 'Delivered') color = Colors.blue;
     
     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
       child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
     );
  }

  Future<void> _updateRequest(String requestId, String status, {String? reason}) async {
    final success = await MedicineService.updateRequestStatus(requestId, status, reason: reason);
    if (success) {
      _fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: TranslatedText('Request $status')));
    }
  }

  void _showRejectDialog(String requestId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TranslatedText('Reject Request'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(hintText: 'Enter reason (e.g. Out of stock)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const TranslatedText('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateRequest(requestId, 'Rejected', reason: reasonCtrl.text.trim());
            },
            child: const TranslatedText('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
