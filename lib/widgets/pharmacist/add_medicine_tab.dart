import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/models/medicine.dart';
import '../../core/user_provider.dart';
import '../../services/medicine_service.dart';
import '../../widgets/translated_text.dart';

class AddMedicineTab extends StatefulWidget {
  final Medicine? editMedicine;
  const AddMedicineTab({super.key, this.editMedicine});

  @override
  State<AddMedicineTab> createState() => _AddMedicineTabState();
}

class _AddMedicineTabState extends State<AddMedicineTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _brandNameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  final _expiryDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _availability = true;
  bool _prescriptionRequired = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.editMedicine != null) {
      _nameController.text = widget.editMedicine!.name;
      _genericNameController.text = widget.editMedicine!.genericName ?? '';
      _brandNameController.text = widget.editMedicine!.brandName ?? '';
      _categoryController.text = widget.editMedicine!.category;
      _expiryDateController.text = widget.editMedicine!.expiryDate;
      _priceController.text = widget.editMedicine!.price.toString();
      _quantityController.text = widget.editMedicine!.stockQuantity.toString();
      _descriptionController.text = widget.editMedicine!.description;
      _manufacturerController.text = widget.editMedicine!.manufacturer;
      _imageUrlController.text = widget.editMedicine!.imageUrl ?? '';
      _availability = widget.editMedicine!.availability;
      _prescriptionRequired = widget.editMedicine!.prescriptionRequired;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final pharmacistId = user?['pharmacistId'] ?? 'unknown';

    final medicine = Medicine(
      id: widget.editMedicine?.id ?? '',
      name: _nameController.text.trim(),
      genericName: _genericNameController.text.trim().isNotEmpty ? _genericNameController.text.trim() : null,
      brandName: _brandNameController.text.trim().isNotEmpty ? _brandNameController.text.trim() : null,
      category: _categoryController.text.trim(),
      expiryDate: _expiryDateController.text.trim(),
      availability: _availability,
      price: double.tryParse(_priceController.text) ?? 0.0,
      stockQuantity: int.tryParse(_quantityController.text) ?? 0,
      description: _descriptionController.text.trim(),
      manufacturer: _manufacturerController.text.trim(),
      prescriptionRequired: _prescriptionRequired,
      imageUrl: _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
      pharmacistId: pharmacistId,
    );

    bool success;
    if (widget.editMedicine == null) {
      success = await MedicineService.addMedicine(medicine);
    } else {
      success = await MedicineService.updateMedicine(widget.editMedicine!.id, medicine.toJson());
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TranslatedText(widget.editMedicine == null ? 'Medicine Added' : 'Medicine Updated'), backgroundColor: Colors.green),
        );
        if (widget.editMedicine == null) {
          _formKey.currentState!.reset();
          _nameController.clear();
          _genericNameController.clear();
          _brandNameController.clear();
          _expiryDateController.clear();
          _priceController.clear();
          _quantityController.text = '0';
          _descriptionController.clear();
          _manufacturerController.clear();
          _imageUrlController.clear();
        } else {
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TranslatedText('Failed to save medicine'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('Medicine Name *', _nameController, Icons.medication_outlined),
            Row(
              children: [
                Expanded(child: _buildTextField('Generic Name', _genericNameController, Icons.science_outlined)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Brand Name', _brandNameController, Icons.branding_watermark_outlined)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildTextField('Category', _categoryController, Icons.category_outlined)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Expiry (MM/YYYY) *', _expiryDateController, Icons.calendar_today_outlined)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildTextField('Price (₹) *', _priceController, Icons.currency_rupee, keyboard: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Stock Quantity *', _quantityController, Icons.numbers, keyboard: TextInputType.number)),
              ],
            ),
            _buildTextField('Manufacturer', _manufacturerController, Icons.business_outlined),
            _buildTextField('Description', _descriptionController, Icons.description_outlined, maxLines: 3),
            _buildTextField('Image URL', _imageUrlController, Icons.image_outlined),
            
            SwitchListTile(
              title: const TranslatedText('Prescription Required'),
              value: _prescriptionRequired,
              onChanged: (v) => setState(() => _prescriptionRequired = v),
              activeColor: AppColors.primaryTeal,
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                child: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : TranslatedText(widget.editMedicine == null ? 'Add Medicine' : 'Save Changes', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: (v) => (label.contains('*') && (v == null || v.isEmpty)) ? 'Required field' : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 20),
              filled: true,
              fillColor: AppColors.adaptiveBackground(context),
            ),
          ),
        ],
      ),
    );
  }
}
