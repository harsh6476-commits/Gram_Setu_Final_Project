import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/models/medicine.dart';
import '../../core/user_provider.dart';
import '../../services/medicine_service.dart';
import '../../widgets/translated_text.dart';
import 'add_medicine_tab.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  bool _isLoading = true;
  List<Medicine> _medicines = [];
  String _searchQuery = '';
  final _searchController = TextEditingController();

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

  void _openEditMedicine(Medicine med) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
              const TranslatedText('Edit Medicine Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(child: AddMedicineTab(editMedicine: med)),
            ],
          ),
        ),
      ),
    );
    
    if (result == true) {
      _fetchMedicines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search your inventory...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
              suffixIcon: _searchQuery.isNotEmpty 
                ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                })
                : null,
            ),
          ),
        ),
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchMedicines,
                child: filteredMedicines.isEmpty
                  ? const Center(child: TranslatedText('No medicines found in your inventory.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredMedicines.length,
                      itemBuilder: (context, index) {
                        return _buildMedicineRow(filteredMedicines[index]);
                      },
                    ),
              ),
        ),
      ],
    );
  }

  List<Medicine> get filteredMedicines {
    if (_searchQuery.isEmpty) return _medicines;
    return _medicines.where((m) => m.name.toLowerCase().contains(_searchQuery.toLowerCase()) || (m.genericName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)).toList();
  }

  Widget _buildMedicineRow(Medicine med) {
    bool isLow = med.stockQuantity > 0 && med.stockQuantity < 10;
    bool isOut = med.stockQuantity <= 0 || !med.availability;
    Color stockColor = isOut ? Colors.red : (isLow ? Colors.orange : Colors.green);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.adaptiveBorder(context).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: stockColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: med.imageUrl != null 
              ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(med.imageUrl!, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.medication, color: stockColor)))
              : Icon(Icons.medication, color: stockColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (med.genericName != null && med.genericName!.isNotEmpty)
                  Text(med.genericName!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('₹${med.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: stockColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('Qty: ${med.stockQuantity}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: stockColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 10, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(med.pharmacistPhone, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primaryTeal, size: 20), onPressed: () => _openEditMedicine(med)),
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => _confirmDelete(med)),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Medicine med) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TranslatedText('Delete Medicine'),
        content: TranslatedText('Are you sure you want to delete ${med.name}? This will remove it from patient browsing.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const TranslatedText('Cancel')),
          TextButton(
            onPressed: () async {
              final success = await MedicineService.deleteMedicine(med.id);
              if (success) {
                Navigator.pop(context);
                _fetchMedicines();
              }
            },
            child: const TranslatedText('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
