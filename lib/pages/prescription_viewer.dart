import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/gram_app_bar.dart';

class PrescriptionViewer extends StatelessWidget {
  const PrescriptionViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adaptiveBackground(context),
      appBar: const GramAppBar(roleLabel: 'My Prescriptions', showBack: true, showSos: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prescriptions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
            const SizedBox(height: 6),
            Text('All your doctor-prescribed medicines', style: TextStyle(fontSize: 14, color: AppColors.adaptiveTextSecondary(context))),
            const SizedBox(height: 20),

            // Active
            _buildSectionLabel(context, 'Active Prescriptions'),
            _buildRx(
              context: context,
              doctor: 'Dr. Sharma',
              date: 'Mar 10, 2026',
              medicines: [
                {'name': 'Paracetamol 500mg', 'dosage': 'Twice daily after meals', 'duration': '5 days'},
                {'name': 'Amoxicillin 250mg', 'dosage': 'Thrice daily', 'duration': '7 days'},
              ],
              notes: 'Take plenty of fluids,  rest for 3 days. Follow up if fever persists more than a week.',
              isActive: true,
              deliveryStatus: 'Ready for pickup at Panchayat',
            ),
            _buildRx(
              context: context,
              doctor: 'Dr. Gupta',
              date: 'Mar 8, 2026',
              medicines: [
                {'name': 'Metformin 500mg', 'dosage': 'Once daily after breakfast', 'duration': '30 days'},
                {'name': 'Amlodipine 5mg', 'dosage': 'Once daily morning', 'duration': '30 days'},
              ],
              notes: 'Monitor blood sugar weekly. Avoid sweets.',
              isActive: true,
              deliveryStatus: 'Delivered ✓',
            ),

            const SizedBox(height: 20),
            _buildSectionLabel(context, 'Past Prescriptions'),
            _buildRx(
              context: context,
              doctor: 'Dr. Patel',
              date: 'Feb 15, 2026',
              medicines: [
                {'name': 'Cetirizine 10mg', 'dosage': 'Once at night', 'duration': '5 days'},
              ],
              notes: 'Skin allergy. Avoid dust.',
              isActive: false,
            ),
            _buildRx(
              context: context,
              doctor: 'Dr. Sharma',
              date: 'Jan 28, 2026',
              medicines: [
                {'name': 'Azithromycin 500mg', 'dosage': 'Once daily', 'duration': '3 days'},
                {'name': 'Cough Syrup', 'dosage': '10ml thrice daily', 'duration': '5 days'},
              ],
              notes: 'Upper respiratory infection. Steam inhalation recommended.',
              isActive: false,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.adaptiveTextPrimary(context))),
    );
  }

  Widget _buildRx({
    required BuildContext context,
    required String doctor,
    required String date,
    required List<Map<String, String>> medicines,
    required String notes,
    required bool isActive,
    String? deliveryStatus,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.adaptiveSurface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isActive ? AppColors.primaryTeal.withValues(alpha: 0.3) : AppColors.adaptiveBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor & date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.doctorGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.medical_services, color: AppColors.doctorGreen, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(doctor, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.adaptiveBackground(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'Active' : 'Completed',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? AppColors.success : AppColors.adaptiveTextSecondary(context)),
                ),
              ),
            ],
          ),
          Text(date, style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context))),
          const SizedBox(height: 12),

          // Medicines
          ...medicines.map((m) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.adaptiveBackground(context), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medication, size: 16, color: AppColors.primaryTeal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['name']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.adaptiveTextPrimary(context))),
                          Text('${m['dosage']}  •  ${m['duration']}', style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context))),
                        ],
                      ),
                    ),
                  ],
                ),
              )),

          // Notes
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notes, size: 14, color: AppColors.adaptiveTextSecondary(context)),
              const SizedBox(width: 6),
              Expanded(child: Text(notes, style: TextStyle(fontSize: 12, color: AppColors.adaptiveTextSecondary(context), fontStyle: FontStyle.italic))),
            ],
          ),

          // Delivery status
          if (deliveryStatus != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping, size: 14, color: AppColors.primaryTeal),
                  const SizedBox(width: 6),
                  Text(deliveryStatus, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryTeal)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
