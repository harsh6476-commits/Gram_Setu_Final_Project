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
    if (!mounted) return;
    setState(() => _isLoading = true);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    
    // Status filtering happens in UI but we fetch all for notifications logic potentially
    final requests = await MedicineService.getPharmacistRequests(pharmacistId: pharmacistId);
    if (!mounted) return;
    setState(() {
      _requests = requests;
      _isLoading = false;
    });
  }

  List<MedicineRequest> get filteredRequests {
    if (_selectedStatus == 'All') return _requests;
    return _requests.where((r) => r.requestStatus == _selectedStatus).toList();
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
    final statuses = ['Pending', 'Approved', 'Rejected', 'Ready for Pickup', 'Out for Delivery', 'Delivered', 'All'];
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.adaptiveBorder(context)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UID: ${request.patientUID}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              _buildStatusIndicator(request.requestStatus),
            ],
          ),
          const SizedBox(height: 12),
          Text(request.medicineName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const TranslatedText('Quantity Requested: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
              Text('${request.quantityRequested}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          if (request.optionalNote != null && request.optionalNote!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Note: ${request.optionalNote}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
            ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(request.patientName, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Icon(Icons.phone, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(request.patientPhone, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButtons(request),
        ],
      ),
    );
  }

  Widget _buildActionButtons(MedicineRequest request) {
    if (request.requestStatus == 'Pending') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(request, 'Approved'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const TranslatedText('Approve', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showRejectDialog(request),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
              child: const TranslatedText('Reject'),
            ),
          ),
        ],
      );
    } else if (request.requestStatus == 'Approved') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(request, 'Ready for Pickup'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const TranslatedText('Ready for Pickup', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(request, 'Out for Delivery'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const TranslatedText('Out for Delivery', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else if (request.requestStatus == 'Out for Delivery' || request.requestStatus == 'Ready for Pickup') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _updateStatus(request, 'Delivered'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
          child: const TranslatedText('Mark Delivered', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatusIndicator(String status) {
     Color color = Colors.grey;
     if (status == 'Pending') color = Colors.orange;
     if (status == 'Approved') color = Colors.green;
     if (status == 'Rejected') color = Colors.red;
     if (status.contains('Delivery') || status.contains('Pickup')) color = Colors.blue;
     if (status == 'Delivered') color = AppColors.primaryTeal;
     
     return Container(
       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
       child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
     );
  }

  Future<void> _updateStatus(MedicineRequest request, String status, {String? reason}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    
    final success = await MedicineService.updateRequestStatus(
      request.id, 
      status, 
      pharmacistId: pharmacistId,
      responseNote: reason
    );
    
    if (success) {
      _fetchRequests();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: TranslatedText('Status set to $status')));
    }
  }

  void _showRejectDialog(MedicineRequest request) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TranslatedText('Reject Request'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(hintText: 'Reason for rejection'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const TranslatedText('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(request, 'Rejected', reason: reasonCtrl.text.trim());
            },
            child: const TranslatedText('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
