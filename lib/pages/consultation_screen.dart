import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/gram_app_bar.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _symptomsController = TextEditingController();
  final String _selectedUrgency = 'Normal';
  bool _submitted = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Request Consultation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 6),
        Text('Describe your symptoms and we will match you with an available doctor.', style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
        const SizedBox(height: 24),

        // Patient info
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.adaptiveSurface(context), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primaryTeal),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Demo User', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
                  Text('UID: UID00VFYV3X3 • Village: Rampur', style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Symptoms
        Text('Describe Symptoms', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'E.g., Fever for 3 days, headache, body pain...'),
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
            onPressed: () => setState(() => _submitted = true),
            child: const Text('Submit Consultation Request'),
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

        // Recent consultations
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Past Consultations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
        ),
        const SizedBox(height: 12),
        _buildPastConsultation('Dr. Sharma', 'Fever, headache', 'Mar 5, 2026', 'Completed'),
        _buildPastConsultation('Dr. Gupta', 'Follow-up visit', 'Feb 20, 2026', 'Completed'),
        _buildPastConsultation('Dr. Patel', 'Skin rash', 'Feb 10, 2026', 'Completed'),
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

  Widget _buildPastConsultation(String doctor, String issue, String date, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.adaptiveSurface(context), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.adaptiveBorder(context))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.doctorGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.medical_services, color: AppColors.doctorGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
                Text(issue, style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: TextStyle(fontSize: 11, color: AppColors.adaptiveTextHint(context))),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
