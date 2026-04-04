import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/models/medicine.dart';
import '../services/medicine_service.dart';
import '../widgets/translated_text.dart';
import 'medicine_request_form.dart';

class MedicineBuyScreen extends StatefulWidget {
  const MedicineBuyScreen({super.key});

  @override
  State<MedicineBuyScreen> createState() => _MedicineBuyScreenState();
}

class _MedicineBuyScreenState extends State<MedicineBuyScreen> {
  bool _isLoading = true;
  List<Medicine> _allMedicines = [];
  List<Medicine> _filteredMedicines = [];
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'All', 'Fever', 'Cold', 'Pain Relief', 'Diabetes', 'BP', 'Vitamins', 'Skin Care'
  ];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    setState(() => _isLoading = true);
    final medicines = await MedicineService.getAllMedicines();
    setState(() {
      _allMedicines = medicines;
      _filteredMedicines = medicines;
      _isLoading = false;
    });
  }

  void _filterMedicines(String query) {
    setState(() {
      _filteredMedicines = _allMedicines.where((med) {
        final matchesQuery = med.name.toLowerCase().contains(query.toLowerCase()) ||
            (med.genericName?.toLowerCase().contains(query.toLowerCase()) ?? false);
        final matchesCategory = _selectedCategory == 'All' || med.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const TranslatedText('Buy Medicines'),
        backgroundColor: theme.cardTheme.color,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchMedicines,
                    child: _filteredMedicines.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _filteredMedicines.length,
                            itemBuilder: (context, index) {
                              return _buildMedicineCard(_filteredMedicines[index]);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMedicines,
              decoration: InputDecoration(
                hintText: 'Search medicine or salt...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.adaptiveBackground(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: _categories.map((cat) => _buildCategoryChip(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String cat) {
    final isSelected = _selectedCategory == cat;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = cat);
        _filterMedicines(_searchController.text);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : AppColors.adaptiveBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.adaptiveBorder(context)),
        ),
        child: Text(
          cat,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.adaptiveTextPrimary(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine med) {
    final isLowStock = med.stockQuantity > 0 && med.stockQuantity < 10;
    final isOutOfStock = med.stockQuantity <= 0 || !med.availability;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.adaptiveBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: med.imageUrl != null 
                    ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(med.imageUrl!, fit: BoxFit.cover))
                    : const Icon(Icons.medication, color: AppColors.primaryTeal, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(med.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('₹${med.price}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                      ],
                    ),
                    if (med.genericName != null)
                      Text(med.genericName!, style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 4),
                    Text(med.description, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStockTag(isOutOfStock, isLowStock),
              if (med.prescriptionRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    children: [
                      Icon(Icons.description_outlined, color: Colors.orange, size: 12),
                      SizedBox(width: 4),
                      Text('Prescription Required', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isOutOfStock 
                  ? () => _notifyMe(med)
                  : () => _openRequestForm(med),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOutOfStock ? Colors.grey : AppColors.primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: TranslatedText(
                isOutOfStock ? 'Notify Me' : 'Request Medicine',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockTag(bool isOut, bool isLow) {
    String text = 'In Stock';
    Color color = Colors.green;
    if (isOut) {
      text = 'Out of Stock';
      color = Colors.red;
    } else if (isLow) {
      text = 'Low Stock';
      color = Colors.orange;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const TranslatedText('Medicine not available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TranslatedText('Try searching for a different medicine or generic name.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              // Manual contact logic
            },
            child: const TranslatedText('Ask Pharmacist via Call'),
          ),
        ],
      ),
    );
  }

  void _notifyMe(Medicine med) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: TranslatedText('We will notify you when ${med.name} is back in stock!')),
    );
  }

  void _openRequestForm(Medicine med) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => MedicineRequestForm(medicine: med, scrollController: controller),
      ),
    );
  }
}
