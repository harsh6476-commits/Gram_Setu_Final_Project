import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/models/medicine.dart';
import '../services/medicine_service.dart';
import '../widgets/gram_app_bar.dart';
import '../widgets/translated_text.dart';

class MedicineBuyScreen extends StatefulWidget {
  const MedicineBuyScreen({super.key});

  @override
  State<MedicineBuyScreen> createState() => _MedicineBuyScreenState();
}

class _MedicineBuyScreenState extends State<MedicineBuyScreen> {
  bool _isLoading = true;
  List<Medicine> _medicines = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Fever', 'Cold', 'Pain Relief', 'Diabetes', 'Blood Pressure', 'Vitamins', 'Skin Care', 'Stomach Problems'
  ];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);
    final meds = await MedicineService.getAllMedicines();
    setState(() {
      _medicines = meds;
      _isLoading = false;
    });
  }

  Future<void> _onSearchChange(String val) async {
    if (val.isEmpty) {
      _fetchMedicines();
    } else {
      final meds = await MedicineService.searchMedicines(val);
      setState(() => _medicines = meds);
    }
  }

  List<Medicine> get filteredMeds {
    if (_selectedCategory == 'All') return _medicines;
    return _medicines.where((m) => m.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: GramAppBar(
        roleLabel: 'Essential Medicines',
        showProfile: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : filteredMeds.isEmpty 
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredMeds.length,
                    itemBuilder: (context, index) => _buildMedicineCard(filteredMeds[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const TranslatedText('Medicine not available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const TranslatedText('Try searching for another medicine', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (v) {
          setState(() => _searchQuery = v);
          _onSearchChange(v);
        },
        decoration: InputDecoration(
          hintText: 'Search for medicnes (e.g. Crocin, Paracetamol)',
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
          suffixIcon: _searchQuery.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                setState(() => _searchQuery = '');
                _fetchMedicines();
              })
            : null,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: TranslatedText(_categories[index], style: TextStyle(color: isSelected ? Colors.white : AppColors.adaptiveTextPrimary(context), fontWeight: FontWeight.bold)),
              selected: isSelected,
              onSelected: (v) => setState(() => _selectedCategory = _categories[index]),
              selectedColor: AppColors.primaryTeal,
              backgroundColor: AppColors.adaptiveSurface(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicineCard(Medicine med) {
    bool isLow = med.stockQuantity > 0 && med.stockQuantity < 10;
    bool isOut = med.stockQuantity <= 0 || !med.availability;
    String statusStr = isOut ? 'Out of Stock' : (isLow ? 'Low Stock' : 'In Stock');
    Color statusColor = isOut ? Colors.red : (isLow ? Colors.orange : Colors.green);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.adaptiveBorder(context).withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
              child: med.imageUrl != null 
                ? ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(med.imageUrl!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.medication, size: 50, color: Colors.grey)))
                : const Icon(Icons.medication, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                if (med.genericName != null && med.genericName!.isNotEmpty)
                  Text(med.genericName!, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${med.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(statusStr, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                if (med.prescriptionRequired)
                   Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [const Icon(Icons.description_outlined, size: 10, color: Colors.orange), const SizedBox(width: 4), const TranslatedText('Rx Required', style: TextStyle(fontSize: 8, color: Colors.orange, fontWeight: FontWeight.bold))])),
                
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: isOut ? null : () => _callPharmacist(med.pharmacistPhone),
                    icon: const Icon(Icons.phone, size: 16, color: Colors.white),
                    label: const TranslatedText('Call Pharmacist', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOut ? Colors.grey : AppColors.primaryTeal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _callPharmacist(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: TranslatedText('Unable to open dialer')));
    }
  }
}
