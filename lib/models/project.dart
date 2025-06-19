import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String location;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final List<String> projectManagerIds;
  final DateTime createdAt;
  final String createdBy;

  // New fields for client details
  final String? clientName;
  final String? clientPhone;
  final String? clientEmail;
  final String? clientCompany;
  final bool? isCommercial;

  // New fields for budget
  final double? budget;
  final String? budgetCurrency;

  // New fields for documents
  final List<String> documentUrls;

  Project({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.projectManagerIds,
    required this.createdAt,
    required this.createdBy,
    this.clientName,
    this.clientPhone,
    this.clientEmail,
    this.clientCompany,
    this.isCommercial,
    this.budget,
    this.budgetCurrency,
    this.documentUrls = const [],
  });

  factory Project.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['start_date'] as Timestamp).toDate(),
      endDate: (data['end_date'] as Timestamp).toDate(),
      status: data['status'] ?? 'Active',
      projectManagerIds: List<String>.from(data['project_manager_ids'] ?? []),
      createdAt: (data['created_at'] as Timestamp).toDate(),
      createdBy: data['created_by'] ?? '',
      clientName: data['client_name'],
      clientPhone: data['client_phone'],
      clientEmail: data['client_email'],
      clientCompany: data['client_company'],
      isCommercial: data['is_commercial'],
      budget: data['budget']?.toDouble(),
      budgetCurrency: data['budget_currency'],
      documentUrls: List<String>.from(data['document_urls'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'start_date': Timestamp.fromDate(startDate),
      'end_date': Timestamp.fromDate(endDate),
      'status': status,
      'project_manager_ids': projectManagerIds,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'client_name': clientName,
      'client_phone': clientPhone,
      'client_email': clientEmail,
      'client_company': clientCompany,
      'is_commercial': isCommercial,
      'budget': budget,
      'budget_currency': budgetCurrency,
      'document_urls': documentUrls,
    };
  }
}
