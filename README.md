# Abiezer Construction CMS

A comprehensive Flutter-based Content Management System (CMS) for Abiezer Construction, designed to streamline construction project management, user authentication, and project-related notifications. This system provides a complete solution for managing construction projects from inception to completion.

## 🌟 Features

### Authentication & User Management
- 🔐 Secure Authentication System with Firebase Auth
- 👥 Role-based Access Control (Admin, Project Manager, User)
- 👤 User Profile Management
- 🔒 Secure Password Management
- 📱 Multi-device Login Support

### Project Management
- 📋 Project Creation and Management
- 📊 Project Dashboard with Key Metrics
- 📝 Project Documentation
- 📅 Project Timeline Management
- 📍 Location-based Project Tracking
- 💰 Budget Management
- 📈 Progress Tracking
- 🏷️ Project Status Updates

### Bill of Materials (BOM)
- 📋 BOM Creation and Management
- 📊 Material Cost Tracking
- 📦 Inventory Management
- 🔄 Material Usage Tracking
- 📝 Material Specifications
- 💰 Cost Estimation

### Purchasing Management
- 🛒 Purchase Order Creation
- 📋 Vendor Management
- 💰 Cost Tracking
- 📊 Purchase History
- 📈 Budget vs. Actual Analysis
- 📝 Purchase Documentation

### Productivity Tracking
- ⏱️ Time Tracking
- 👥 Team Performance Metrics
- 📊 Productivity Reports
- 📈 Efficiency Analysis
- 📝 Daily Progress Reports

### Reporting System
- 📊 Custom Report Generation
- 📈 Data Visualization
- 📑 Export Reports (PDF, Excel)
- 📊 Financial Reports
- 📈 Project Performance Reports
- 📊 Resource Utilization Reports

### Approval System
- ✅ Multi-level Approval Workflow
- 📝 Document Approval
- 💰 Cost Approval
- 📋 Change Request Approval
- 📊 Approval History

### Real-time Features
- 🔔 Push Notifications
- 📱 Real-time Updates
- 💬 In-app Messaging
- 📊 Live Dashboard Updates
- 🔄 Synchronization Across Devices

### Document Management
- 📄 Document Upload and Storage
- 📁 File Organization
- 🔍 Document Search
- 📝 Version Control
- 🔒 Secure Document Access

## 📱 Application Screens

### Authentication Screens
- Login Screen
- Registration Screen
- Password Reset Screen
- Email Verification Screen

### Admin Screens (Implemented)
- Admin Dashboard
  - Overview of all projects
  - Active projects count
  - Low-stock materials monitoring
  - Recent project activities
  - Pending actions
  - Real-time notifications
  - Activity log
- User Management
  - User listing
  - User role assignment
  - User status management
- Project Management
  - Project creation and editing
  - Project status updates
  - Project assignment
  - Project timeline management
- BOM Management
  - BOM creation
  - Material tracking
  - Cost management
  - Inventory alerts
- System Settings
  - Application configuration
  - User permissions
  - System preferences

### Project Manager Screens (Implemented)
- Project Manager Dashboard
  - Assigned projects overview
  - Project metrics
  - Low-stock materials alerts
  - Pending requests
  - Recent notifications
  - Project status updates
- Project Details
  - Project information
  - Team management
  - Resource allocation
  - Progress tracking
  - Budget monitoring
- BOM Managementz
  - Material requirements
  - Cost tracking
  - Inventory management
  - Purchase requests
- Team Management
  - Team member assignment
  - Task distribution
  - Performance tracking
  - Resource allocation

### Project Management Screens
- Project Dashboard
- Project Details
- Project Timeline
- Project Documents
- Project Team
- Project Budget
- Project Reports

### BOM Screens
- BOM Creation
- BOM List
- BOM Details
- Material Management
- Cost Analysis

### Purchase Management Screens
- Purchase Orders
- Vendor Management
- Purchase History
- Cost Tracking
- Budget Analysis

### Productivity Screens
- Time Tracking
- Team Performance
- Daily Reports
- Efficiency Analysis

### Report Screens
- Report Generation
- Data Visualization
- Export Options
- Custom Reports

### Settings Screens
- User Profile
- Application Settings
- Notification Settings
- System Preferences

## 🛠️ Technical Features

### State Management
- Provider-based State Management
- Real-time Data Synchronization
- Offline Data Persistence
- Efficient Data Caching

### Firebase Integration
- Firebase Authentication
- Cloud Firestore Database
- Firebase Storage
- Firebase Analytics
- Real-time Updates

### UI/UX Features
- Material Design Implementation
- Responsive Layout
- Custom Theme Support
- Dark/Light Mode
- Loading Animations
- Error Handling
- Form Validation

### Security Features
- Secure Authentication
- Role-based Access Control
- Data Encryption
- Secure File Storage
- Session Management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase Account
- Android Studio / Xcode (for mobile development)
- VS Code (recommended IDE)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd abiezer_cms
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your Firebase configuration files:
     - For Android: `android/app/google-services.json`
     - For iOS: `ios/Runner/GoogleService-Info.plist`
     - For Web: Configure Firebase in `web/index.html`

4. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── config/         # Configuration files
├── core/          # Core functionality
├── features/      # Feature-based modules
├── models/        # Data models
├── providers/     # State management
├── screens/       # UI screens
│   ├── admin/    # Admin screens
│   ├── auth/     # Authentication screens
│   ├── bom/      # Bill of Materials screens
│   ├── dashboard/# Dashboard screens
│   ├── projects/ # Project management screens
│   ├── reports/  # Reporting screens
│   └── settings/ # Settings screens
├── services/      # Business logic and API services
├── utils/         # Utility functions
└── widgets/       # Reusable widgets
```

## 📦 Dependencies

### Firebase
- firebase_core: ^2.24.2
- firebase_auth: ^4.16.0
- cloud_firestore: ^4.14.0
- firebase_storage: ^11.6.0
- firebase_analytics: ^10.8.6

### State Management
- provider: ^6.1.1

### UI Components
- flutter_spinkit: ^5.2.0
- cached_network_image: ^3.3.1
- flutter_svg: ^2.0.9

### Utilities
- image_picker: ^1.1.2
- intl: ^0.19.0
- connectivity_plus: ^6.1.4
- shared_preferences: ^2.5.3
- path_provider: ^2.1.5
- uuid: ^4.5.1

## 💻 Development

### Code Style
This project follows the official Dart style guide. Run the following command to check your code style:

```bash
flutter analyze
```

### Testing
Run tests using:

```bash
flutter test
```

## 📱 Deployment

### Android
1. Update version in `pubspec.yaml`
2. Run:
```bash
flutter build apk --release
```

### iOS
1. Update version in `pubspec.yaml`
2. Run:
```bash
flutter build ios --release
```

### Web
1. Update version in `pubspec.yaml`
2. Run:
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is proprietary and confidential. All rights reserved.

## 📞 Support

For support, please contact [Your Contact Information]
