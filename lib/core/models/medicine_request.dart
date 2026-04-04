class MedicineRequest {
  final String id;
  final String patientName;
  final String phone;
  final String? location;
  final String? address;
  final String medicineId;
  final String? medicineName; // Populated from join or secondary fetch
  final int quantity;
  final String? notes;
  final String status;
  final String? prescriptionUrl;
  final String? pharmacistId;
  final String? rejectionReason;
  final DateTime createdAt;

  MedicineRequest({
    required this.id,
    required this.patientName,
    required this.phone,
    this.location,
    this.address,
    required this.medicineId,
    this.medicineName,
    this.quantity = 1,
    this.notes,
    this.status = 'Pending',
    this.prescriptionUrl,
    this.pharmacistId,
    this.rejectionReason,
    required this.createdAt,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) {
    return MedicineRequest(
      id: json['_id'] ?? '',
      patientName: json['patientName'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'],
      address: json['address'],
      medicineId: json['medicineId']?['_id'] ?? json['medicineId'] ?? '',
      medicineName: json['medicineId']?['name'] ?? json['medicineName'],
      quantity: json['quantity'] ?? 1,
      notes: json['notes'],
      status: json['status'] ?? 'Pending',
      prescriptionUrl: json['prescriptionUrl'],
      pharmacistId: json['pharmacistId'],
      rejectionReason: json['rejectionReason'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'phone': phone,
      'location': location,
      'address': address,
      'medicineId': medicineId,
      'quantity': quantity,
      'notes': notes,
      'status': status,
      'prescriptionUrl': prescriptionUrl,
      'pharmacistId': pharmacistId,
      'rejectionReason': rejectionReason,
    };
  }
}
