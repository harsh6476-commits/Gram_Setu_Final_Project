import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/models/medicine.dart';
import '../core/models/medicine_request.dart';
import '../services/medicine_service.dart';
import '../widgets/translated_text.dart';

class MedicineRequestForm extends StatefulWidget {
  final Medicine medicine;
  final ScrollController scrollController;

  const MedicineRequestForm({
    super.key,
    required this.medicine,
    required this.scrollController,
  });

  @override
  State<MedicineRequestForm> createState() => _MedicineRequestFormState();
}

class _MedicineRequestFormState extends State<MedicineRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _noteController = TextEditingController();
  bool _isPrescriptionUploaded = false;
  bool _isSubmitting = false;

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (widget.medicine.prescriptionRequired && !_isPrescriptionUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Prescription is required for this medicine'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final request = MedicineRequest(
      id: '',
      patientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _villageController.text.trim(),
      address: _addressController.text.trim(),
      medicineId: widget.medicine.id,
      quantity: int.tryParse(_quantityController.text) ?? 1,
      notes: _noteController.text.trim(),
      status: 'Pending',
      prescriptionUrl: _isPrescriptionUploaded ? 'demo_url.jpg' : null,
      createdAt: DateTime.now(),
    );

    final success = await MedicineService.requestMedicine(request);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.pop(context);
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TranslatedText('Failed to send request. Please try again.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TranslatedText('Request Submitted!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const TranslatedText('Your medicine request has been sent to the pharmacist.'),
            const SizedBox(height: 8),
            const TranslatedText('Estimated response time: 2-4 hours'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const TranslatedText('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
          ),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TranslatedText('Requesting Medicine', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          Text(widget.medicine.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.medicine.imageUrl != null 
                        ? Image.network(widget.medicine.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.medication, size: 40, color: AppColors.primaryTeal),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Full Name', _nameController, Icons.person_outline),
                      _buildTextField('Mobile Number', _phoneController, Icons.phone_outlined, keyboard: TextInputType.phone),
                      _buildTextField('Village / Area', _villageController, Icons.location_on_outlined),
                      _buildTextField('Address Details', _addressController, Icons.home_outlined),
                      
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Quantity', _quantityController, Icons.format_list_numbered, keyboard: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: Container()),
                        ],
                      ),
                      
                      _buildTextField('Additional Notes', _noteController, Icons.note_alt_outlined, maxLines: 2),
                      
                      if (widget.medicine.prescriptionRequired) ...[
                        const SizedBox(height: 8),
                        _buildPrescriptionUpload(),
                      ],
                      
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitRequest,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                          child: _isSubmitting 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const TranslatedText('Submit Request', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
            validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryTeal),
              filled: true,
              fillColor: AppColors.adaptiveBackground(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionUpload() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText('Upload Prescription', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    TranslatedText('Camera photo or PDF accepted', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isPrescriptionUploaded)
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const TranslatedText('Prescription uploaded successfully', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => setState(() => _isPrescriptionUploaded = false), icon: const Icon(Icons.close, size: 16)),
              ],
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                // Mock upload
                setState(() => _isPrescriptionUploaded = true);
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const TranslatedText('Click to Upload'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                foregroundColor: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}
