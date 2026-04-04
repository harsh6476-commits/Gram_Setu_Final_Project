import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/medicine.dart';
import '../../core/user_provider.dart';
import '../../services/medicine_service.dart';
import '../../widgets/translated_text.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool _isLoading = true;
  List<Medicine> _medicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? '';
    final medicines = await MedicineService.getPharmacistInventory(pharmacistId);
    setState(() {
      _medicines = medicines;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _notifications {
    List<Map<String, dynamic>> notes = [];
    
    for (var med in _medicines) {
      if (med.stockQuantity <= 0) {
        notes.add({
          'title': 'Out of Stock',
          'message': '${med.name} is currently out of stock!',
          'icon': Icons.error_outline,
          'color': Colors.red,
        });
      } else if (med.stockQuantity < 10) {
        notes.add({
          'title': 'Low Stock Warning',
          'message': '${med.name} stock level is low (${med.stockQuantity})',
          'icon': Icons.warning_amber_outlined,
          'color': Colors.orange,
        });
      }
      
      // Expiry warnings (MM/YYYY)
      try {
        final expParts = med.expiryDate.split('/');
        if (expParts.length == 2) {
           final month = int.parse(expParts[0]);
           final year = int.parse(expParts[1]);
           final expDate = DateTime(year, month);
           final now = DateTime.now();
           final diff = expDate.difference(now).inDays;
           
           if (diff < 0) {
              notes.add({
                'title': 'Expired Medicine',
                'message': '${med.name} has already expired!',
                'icon': Icons.timer_off_outlined,
                'color': Colors.red,
              });
           } else if (diff < 30) {
              notes.add({
                'title': 'Expiring Soon',
                'message': '${med.name} will expire in about ${diff} days!',
                'icon': Icons.timer_outlined,
                'color': Colors.orange,
              });
           }
        }
      } catch (e) {}
    }
    
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final notes = _notifications;
    
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              const TranslatedText('Critical Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (!_isLoading) IconButton(onPressed: _fetchMedicines, icon: const Icon(Icons.refresh, size: 20)),
            ],
          ),
        ),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        TranslatedText('No urgent stock alerts.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final n = notes[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (n['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: (n['color'] as Color).withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(n['icon'], color: n['color']),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TranslatedText(n['title'], style: TextStyle(fontWeight: FontWeight.bold, color: n['color'])),
                                  const SizedBox(height: 4),
                                  TranslatedText(n['message'], style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
