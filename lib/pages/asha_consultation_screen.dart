import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/gram_app_bar.dart';

class AshaConsultationScreen extends StatefulWidget {
  const AshaConsultationScreen({super.key});

  @override
  State<AshaConsultationScreen> createState() => _AshaConsultationScreenState();
}

class _AshaConsultationScreenState extends State<AshaConsultationScreen> {
  final _uidController = TextEditingController();
  final _symptomsController = TextEditingController();
  bool _isSubmitted = false;
  bool _isLoading = false;
  bool _patientFound = false;
  String _patientName = '';

  @override
  void dispose() {
    _uidController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  void _lookupPatient() {
    final uid = _uidController.text.trim();
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a Patient UID')));
      return;
    }
    // Simulating patient lookup
    setState(() {
      _patientFound = true;
      _patientName = 'Ramesh Yadav';
    });
  }

  Future<void> _submitConsultation() async {
    if (_symptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe symptoms')));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const GramAppBar(roleLabel: 'Book Consultation', showBack: true, showSos: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _isSubmitted ? _buildSuccessView(theme) : _buildFormView(theme),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Book Consultation for Patient', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.displayLarge?.color)),
        const SizedBox(height: 6),
        Text('Enter patient UID to book a doctor consultation on their behalf.', style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color)),
        const SizedBox(height: 24),

        // Patient UID Lookup
        Text('Patient UID', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _uidController,
                decoration: InputDecoration(
                  hintText: 'e.g., UID003829',
                  prefixIcon: Icon(Icons.badge_outlined, color: AppColors.ashaWorkerPink),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _lookupPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ashaWorkerPink,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Find', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Patient Info Card (shown after lookup)
        if (_patientFound)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person, color: AppColors.success),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_patientName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color)),
                      Text('UID: ${_uidController.text} • Village: Rampur', style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: AppColors.success),
              ],
            ),
          ),

        if (_patientFound) ...[
          const SizedBox(height: 24),

          // Symptoms
          Text('Describe Symptoms', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 8),
          TextField(
            controller: _symptomsController,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'E.g., Fever for 3 days, headache, body pain...'),
          ),
          const SizedBox(height: 16),

          // Common Symptoms Quick Select
          Text('Quick Symptoms', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Fever', 'Headache', 'Cold/Cough', 'Body Pain', 'Stomach Pain', 'Dizziness', 'Skin Rash', 'Chest Pain', 'Weakness', 'Vomiting'].map((s) {
              return ActionChip(
                label: Text(s, style: const TextStyle(fontSize: 12)),
                onPressed: () {
                  final current = _symptomsController.text;
                  _symptomsController.text = current.isEmpty ? s : '$current, $s';
                },
                backgroundColor: theme.cardTheme.color,
                side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.15)),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitConsultation,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ashaWorkerPink),
              child: _isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Book Consultation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
        ),
        const SizedBox(height: 24),
        Text('Consultation Booked!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.textTheme.displayLarge?.color)),
        const SizedBox(height: 8),
        Text('A doctor will be matched with the patient shortly.', style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color)),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              _infoRow(theme, 'Patient', _patientName),
              _infoRow(theme, 'UID', _uidController.text),
              _infoRow(theme, 'Symptoms', _symptomsController.text),
              _infoRow(theme, 'Status', 'Matching doctor...'),
              _infoRow(theme, 'Est. Wait', '~15 minutes'),
            ],
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ashaWorkerPink),
            child: const Text('Back to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color)),
          const SizedBox(width: 16),
          Flexible(child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
