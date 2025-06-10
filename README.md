# Abiezer Construction Management System

A Flutter-based Construction Management System that helps manage construction projects, materials, and team collaboration.

## Features

- 🔐 Secure Authentication System
- 📱 Cross-platform Support (iOS, Android, Web)
- 🏗️ Project Management
- 📊 Bill of Materials (BOM) Management
- 🔔 Real-time Notifications
- 📸 Image Upload and Management
- 🔄 Offline Support
- 📈 Analytics Integration

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase Account
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
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
     - For Web: Add the Firebase configuration to `web/index.html`

4. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── config/         # Configuration files
├── providers/      # State management providers
├── screens/        # UI screens
├── widgets/        # Reusable widgets (e.g. ProjectCard)
├── utils/          # Utility functions and constants
└── main.dart       # Application entry point
```

## Dependencies

- **Firebase**
  - firebase_core: ^2.24.2
  - firebase_auth: ^4.16.0
  - cloud_firestore: ^4.14.0
  - firebase_storage: ^11.6.0
  - firebase_analytics: ^10.8.6

- **State Management**
  - provider: ^6.1.1

- **UI Components**
  - flutter_spinkit: ^5.2.0
  - cached_network_image: ^3.3.1
  - flutter_svg: ^2.0.9

- **Utilities**
  - intl: ^0.19.0
  - connectivity_plus: ^6.1.4
  - shared_preferences: ^2.5.3
  - path_provider: ^2.1.5
  - uuid: ^4.5.1
  - rxdart: ^0.28.0

## Development

### Code Style

This project follows the Flutter style guide and uses the `flutter_lints` package for code quality. Run the following command to check for lint issues:

```bash
flutter analyze
```

### Testing

Run the tests using:

```bash
flutter test
```

## Deployment

### Android

1. Update the version in `pubspec.yaml`
2. Run:
```bash
flutter build apk --release
```

### iOS

1. Update the version in `pubspec.yaml`
2. Run:
```bash
flutter build ios --release
```

### Web

1. Update the version in `pubspec.yaml`
2. Run:
```bash
flutter build web --release
```

## Project Manager BOM Tab (New)

### Overview
The Project Manager's Bill of Materials (BOM) tab has been redesigned for a modern, responsive, and user-friendly experience. It now features:

- **Responsive Project Card Grid:**
  - Projects are displayed as cards in a grid (1 column on mobile, 3 on desktop/tablet).
  - Each card shows project name, status chip, location, date range, description, and manager(s) in italics.
- **Assigned vs. All Projects:**
  - Two main sections: "Projects Assigned to Me" and "All Projects" (toggle between them).
  - If the user is not assigned to a project, a lock icon with a tooltip appears and the "View BOM" button is disabled/hidden.
  - If the user is assigned, the "View BOM" button is enabled.
- **No Projects State:**
  - If no projects are assigned, a clear empty state is shown.
- **Reusable Components:**
  - The `ProjectCard` widget is used for consistent, maintainable UI.

### Example Card UI
```
+-------------------------------+
| Project A         [Active]    |
| 📍 2nd Avenue                |
| 📅 2025-06-30 - 2025-09-30   |
| 📝 this is a home...         |
| 👤 Sarah Brown (italic)      |
|                [View BOM]    |
+-------------------------------+
```
If not assigned:
```
+-------------------------------+
| Project B         [Active] 🔒 |
| ...                           |
|        (View BOM disabled)    |
+-------------------------------+
```

### Navigation
- Only assigned projects allow navigation to BOM details.
- All projects are visible for reference, but unassigned projects are locked.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email [your-email] or create an issue in the repository.

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
- 🆕 **Recent UI/UX Improvements**
  - Material list is now compact, modern, and visually appealing
  - Adjust and Audit Trail buttons are inline with the progress bar for each material
  - Audit Trail opens in a modal dialog for better usability
  - 'Request More' button is hidden for admin users
  - Material Requests section removed from the Bill of Materials view for projects
- 🕵️ **Audit Trail for BOM**
  - View a complete history of all changes and adjustments
  - See who made each change, when, and what was changed
  - Access the Audit Trail via a button next to 'Edit Bill of Materials'
  - Combines BOM edits, material usage, and movement logs in a single view

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

## 🛠️ Technical Stack

### Core Technologies
- Flutter (>=3.0.0)
- Dart (>=3.0.0)
- Firebase Services
  - Authentication
  - Cloud Firestore
  - Storage
  - Analytics

### Key Dependencies
- `firebase_core: ^2.24.2`
- `firebase_auth: ^4.16.0`
- `cloud_firestore: ^4.14.0`
- `firebase_storage: ^11.6.0`
- `firebase_analytics: ^10.8.6`
- `provider: ^6.1.1` (State Management)
- `image_picker: ^1.1.2`
- `flutter_spinkit: ^5.2.0`
- `intl: ^0.19.0`
- `cached_network_image: ^3.3.1`
- `flutter_svg: ^2.0.9`
- `connectivity_plus: ^6.1.4`
- `shared_preferences: ^2.5.3`
- `path_provider: ^2.1.5`
- `uuid: ^4.5.1`
- `rxdart: ^0.28.0`

## 📁 Project Structure

```
lib/
├── main.dart
├── config/
├── models/
├── screens/
├── services/
├── utils/
└── widgets/

assets/
├── images/
└── icons/

test/
└── unit/
```

## 🔧 Development

### Code Style
- Follow the Flutter style guide
- Use the provided `analysis_options.yaml` for linting
- Run `flutter analyze` before committing changes

### Testing
- Write unit tests for critical functionality
- Run tests using `flutter test`
- Ensure all tests pass before submitting PRs

### Building for Production
1. Update version in `pubspec.yaml`
2. Run `flutter build apk` for Android
3. Run `flutter build ios` for iOS
4. Run `flutter build web` for web deployment

## 📱 Platform Support
- Android
- iOS
- Web
- macOS
- Windows
- Linux

## 🔐 Security
- All sensitive data is encrypted
- Firebase Security Rules implemented
- Regular security audits
- Secure authentication flow
- Role-based access control

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License
This project is proprietary and confidential. All rights reserved.

## 👥 Support
For support, please contact the development team or raise an issue in the repository.

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
- BOM Management
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
