import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/user_provider.dart';
import '../widgets/gram_app_bar.dart';
import '../services/api_service.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _symptomsController = TextEditingController();
  final _uidController = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;
  final String _selectedUrgency = 'Normal';

  @override
  void dispose() {
    _symptomsController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String uid = userProvider.user?['uid'] ?? _uidController.text.trim();
    final String problem = _symptomsController.text.trim();

    if (uid.isEmpty || problem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter UID and describe the symptoms')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post('/consultations/request', {
        'uid': uid,
        'problem': problem,
      });

      if (response.statusCode == 201) {
        setState(() {
          _submitted = true;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to submit: ${response.body}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: const GramAppBar(roleLabel: 'Book Consultation', showBack: true, showSos: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _submitted ? _buildSubmittedView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    final user = Provider.of<UserProvider>(context).user;
    final bool isLoggedIn = user != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Request Consultation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 6),
        Text('Describe your symptoms and we will match you with an available doctor.', style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
        const SizedBox(height: 24),

        // Patient info / UID Input
        isLoggedIn 
        ? Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.adaptiveSurface(context), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primaryTeal),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'] ?? 'User', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
                  Text('UID: ${user['uid'] ?? 'N/A'} • Village: ${user['village'] ?? 'N/A'}', style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context))),
                ],
              ),
            ],
          ),
        )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient UID / Aadhar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
              const SizedBox(height: 8),
              TextField(
                controller: _uidController,
                decoration: InputDecoration(
                  hintText: 'Enter 12-digit UID',
                  filled: true,
                  fillColor: AppColors.adaptiveSurface(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),

        // Symptoms
        Text('Describe Symptoms / Problem', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'E.g., Fever for 3 days, headache, body pain...',
            filled: true,
            fillColor: AppColors.adaptiveSurface(context),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),

        // Common symptoms quick select
        Text('Common Symptoms', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Fever', 'Headache', 'Cold/Cough', 'Body Pain', 'Stomach Pain', 'Dizziness', 'Skin Rash', 'Chest Pain'].map((s) {
            return ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 12)),
              onPressed: () {
                final current = _symptomsController.text;
                _symptomsController.text = current.isEmpty ? s : '$current, $s';
              },
              backgroundColor: AppColors.adaptiveSurface(context),
              side: BorderSide(color: AppColors.adaptiveBorder(context)),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitRequest,
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Submit Consultation Request'),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittedView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
        ),
        const SizedBox(height: 24),
        Text('Consultation Requested!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 8),
        Text('We are matching you with an available doctor.', style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.adaptiveSurface(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.adaptiveBorder(context)),
          ),
          child: Column(
            children: [
              _infoRow('Submitted', 'Just now'),
              _infoRow('Urgency', _selectedUrgency),
              _infoRow('Status', 'Matching doctor...'),
              _infoRow('Est. Wait', '~15 minutes'),
            ],
          ),
        ),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        )
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
        ],
      ),
    );
  }
}
