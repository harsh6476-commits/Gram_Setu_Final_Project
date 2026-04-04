class MedicineRequest {
  final String id;
  final String patientUID;
  final String patientName;
  final String patientPhone;
  final String medicineId;
  final String medicineName;
  final int quantityRequested;
  final String? prescriptionUrl;
  final String? optionalNote;
  final String requestStatus;
  final String? pharmacistId;
  final String? pharmacistResponse;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicineRequest({
    required this.id,
    required this.patientUID,
    required this.patientName,
    required this.patientPhone,
    required this.medicineId,
    required this.medicineName,
    this.quantityRequested = 1,
    this.prescriptionUrl,
    this.optionalNote,
    this.requestStatus = 'Pending',
    this.pharmacistId,
    this.pharmacistResponse,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) {
    return MedicineRequest(
      id: json['_id'] ?? '',
      patientUID: json['patientUID'] ?? '',
      patientName: json['patientName'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      medicineId: (json['medicineId'] is Map) ? json['medicineId']['_id'] : (json['medicineId'] ?? ''),
      medicineName: json['medicineName'] ?? ((json['medicineId'] is Map) ? json['medicineId']['name'] : 'Unknown'),
      quantityRequested: json['quantityRequested'] ?? json['quantity'] ?? 1,
      prescriptionUrl: json['prescriptionUrl'],
      optionalNote: json['optionalNote'] ?? json['notes'],
      requestStatus: json['requestStatus'] ?? json['status'] ?? 'Pending',
      pharmacistId: json['pharmacistId'],
      pharmacistResponse: json['pharmacistResponse'] ?? json['rejectionReason'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientUID': patientUID,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantityRequested': quantityRequested,
      'prescriptionUrl': prescriptionUrl,
      'optionalNote': optionalNote,
      'requestStatus': requestStatus,
      'pharmacistId': pharmacistId,
      'pharmacistResponse': pharmacistResponse,
    };
  }
}
