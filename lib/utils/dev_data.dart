import '../models/project_model.dart';
import '../models/notification_model.dart';
import '../models/request_model.dart';

/// This file contains test data for development and testing.
/// In a production environment, this data would come from Firestore.

class DevData {
  // Sample Projects
  static List<ProjectModel> projects = [
    ProjectModel(
      id: 'project-1',
      name: 'Residential Complex A',
      description: 'Construction of 50-unit residential complex',
      location: 'Cape Town CBD',
      status: 'active',
      startDate: DateTime(2023, 5, 10),
      endDate: DateTime(2024, 11, 30),
      projectManagers: ['pm-user-1'],
      client: 'Coastal Properties Ltd',
      budget: 15000000.0,
      imageUrl: 'https://example.com/project1.jpg',
    ),
    ProjectModel(
      id: 'project-2',
      name: 'Office Tower B',
      description: 'Construction of 20-story office building',
      location: 'Johannesburg Central',
      status: 'active',
      startDate: DateTime(2023, 6, 15),
      endDate: DateTime(2025, 2, 28),
      projectManagers: ['pm-user-1', 'pm-user-2'],
      client: 'Business Towers Inc',
      budget: 28000000.0,
      imageUrl: 'https://example.com/project2.jpg',
    ),
    ProjectModel(
      id: 'project-3',
      name: 'Shopping Mall Renovation',
      description: 'Renovation of existing shopping mall',
      location: 'Durban North',
      status: 'active',
      startDate: DateTime(2023, 7, 1),
      endDate: DateTime(2024, 4, 30),
      projectManagers: ['pm-user-1'],
      client: 'Retail Developers SA',
      budget: 12000000.0,
      imageUrl: 'https://example.com/project3.jpg',
    ),
  ];

  // Sample Notifications
  static List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif-1',
      title: 'Low Stock Alert',
      message:
          'Cement in Project "Residential Complex A" is running low (10 bags remaining)',
      type: NotificationType.lowStock,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      userId: 'pm-user-1',
      projectId: 'project-1',
    ),
    NotificationModel(
      id: 'notif-2',
      title: 'Request Approved',
      message: 'Your material request for Steel Rebar has been approved',
      type: NotificationType.materialApproval,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      userId: 'pm-user-1',
      projectId: 'project-2',
    ),
    NotificationModel(
      id: 'notif-3',
      title: 'System Update',
      message:
          'The app will be undergoing maintenance tonight from 02:00-04:00',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      userId: 'all',
    ),
  ];

  // Sample Requests
  static List<RequestModel> requests = [
    RequestModel(
      id: 'req-1',
      type: 'material',
      materialId: 'mat-1',
      materialName: 'Cement',
      quantity: 50.0,
      unit: 'bags',
      projectId: 'project-1',
      requestedBy: 'pm-user-1',
      status: 'pending',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      approvedBy: '',
      reason: 'Current stock is low and we need to complete foundation work',
    ),
    RequestModel(
      id: 'req-2',
      type: 'purchase',
      materialId: 'mat-2',
      materialName: 'Steel Rebar',
      quantity: 2.0,
      unit: 'tons',
      projectId: 'project-2',
      requestedBy: 'pm-user-1',
      status: 'pending',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      approvedBy: '',
      reason: 'Required for the next phase of structural work',
    ),
  ];
}
