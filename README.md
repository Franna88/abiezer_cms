# 🏗️ Abiezer Construction Management System (CMS)

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](pubspec.yaml)

A modern, Flutter-based Construction Management System designed to streamline construction project management, materials tracking, and team collaboration. Built with Firebase backend for real-time data synchronization and cross-platform support.

## 📋 Table of Contents

- [🌟 Features](#-features)
- [🚀 Quick Start](#-quick-start)
- [📱 Screenshots](#-screenshots)
- [🏗️ Architecture](#️-architecture)
- [📁 Project Structure](#-project-structure)
- [🔧 Setup & Installation](#-setup--installation)
- [🔥 Firebase Configuration](#-firebase-configuration)
- [📦 Dependencies](#-dependencies)
- [🧪 Testing](#-testing)
- [📱 Deployment](#-deployment)
- [🔧 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🌟 Features

### 🔐 Authentication & Security
- **Firebase Authentication** - Secure user login and registration
- **Role-based Access Control** - Admin, Project Manager, and User roles
- **Multi-device Support** - Seamless login across devices
- **Secure Password Management** - Industry-standard security practices

### 📊 Project Management
- **Project Dashboard** - Real-time project metrics and overview
- **Project Creation & Management** - Complete project lifecycle management with multi-step forms
- **Project Image Upload** - Add a representative image to each project for better visual identification.
- **Timeline Tracking** - Milestone and deadline management
- **Team Assignment** - Assign and manage project teams with an intuitive pop-up dialog, including search functionality
- **Responsive Team View** - Modern, responsive grid layout for viewing assigned project managers
- **Project Details View** - Comprehensive project information with client details and budget tracking
- **Status Management** - Active, Pending, On Hold, Completed, and Cancelled statuses

### 📋 Bill of Materials (BOM)
- **Material List Management** - Comprehensive material tracking with categories
- **Cost Estimation** - Real-time cost calculations and tracking in ZAR currency
- **Inventory Management** - Stock level monitoring and low-stock alerts
- **Material Movement Tracking** - Log usage, transfers, returns, and leftovers
- **Real-time Updates** - Live synchronization across all devices
- **Photo Documentation** - Image capture for material verification

### 👥 User Management
- **Project Manager Assignment** - Searchable, multi-select project manager assignment via a pop-up dialog
- **Role-based Permissions** - Different access levels for admins and project managers
- **User Profiles** - Comprehensive user information management
- **Team Collaboration** - Enhanced team coordination tools

### 📱 Cross-Platform Support
- **iOS & Android** - Native mobile applications
- **Web Support** - Progressive Web App (PWA) ready
- **Offline Capability** - Work without internet connection
- **Responsive Design** - Optimized for all screen sizes (mobile, tablet, desktop)

### 🔔 Notifications & Alerts
- **Low-Stock Alerts** - Automatic notifications for materials below threshold
- **Request Management** - Material request workflow with approval system
- **Activity Timeline** - Real-time project activity tracking
- **In-app Notifications** - Push notifications for important updates

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (>=3.0.0)
- **Dart SDK** (>=3.0.0)
- **Firebase Account** - For backend services
- **Android Studio / Xcode** - For mobile development
- **Python 3.x** - For Firebase data management scripts

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/abiezer_cms.git
   cd abiezer_cms
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Python dependencies** (if using Firebase scripts)
   ```bash
   pip install firebase-admin>=6.2.0
   ```

4. **Configure Firebase** (see [Firebase Configuration](#-firebase-configuration))

5. **Run the application**
   ```bash
   # For mobile development
   flutter run
   
   # For web development
   flutter run -d chrome
   
   # For specific device
   flutter devices
   flutter run -d <device-id>
   ```

### First Time Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication, Firestore, Storage, and Analytics

2. **Download Configuration Files**
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Web: Add to `web/index.html` and ensure the Firebase SDK scripts are modular (using `type="module"`).

3. **Set up Firestore Rules**
   - Copy `firestore.rules` content to Firebase Console
   - Deploy rules: `firebase deploy --only firestore:rules`

4. **Create Database Indexes**
   ```bash
   python create_indexes.py --creds path/to/serviceAccountKey.json
   ```

5. **Configure CORS for Firebase Storage (Web Development)**
   - For web development, you'll need to configure CORS on your Firebase Storage bucket to allow uploads from `localhost`.
   - A sample `cors.json` file is included in the project root.
   - Apply the rules using `gsutil`:
     ```bash
     # Make sure you are authenticated: gcloud auth login
     # Set the correct project: gcloud config set project <your-firebase-project-id>
     gsutil cors set cors.json gs://<your-firebase-project-id>.appspot.com
   ```

## 📱 Screenshots

*Screenshots will be added here showing the main features of the application, including the new project image feature.*

## 🏗️ Architecture

The application follows a clean architecture pattern with the following layers:

- **Presentation Layer** - UI screens and widgets with responsive design
- **Business Logic Layer** - Providers and state management using Provider pattern
- **Data Layer** - Services and models with Firebase integration
- **Infrastructure Layer** - Firebase integration and utilities

### State Management
- **Provider Pattern** - For state management across the app
- **Firebase Real-time Updates** - Live data synchronization
- **Local Storage** - Offline data persistence with SharedPreferences

### Design Patterns
- **Feature-based Architecture** - Organized by business features
- **Repository Pattern** - Data access abstraction
- **Service Layer** - Business logic separation
- **Widget Composition** - Reusable UI components

## 📁 Project Structure

```
abiezer_cms/
├── lib/                          # Flutter application code
│   ├── config/                   # Configuration files
│   │   └── firebase_options.dart # Firebase configuration
│   ├── core/                     # Core functionality
│   │   ├── constants/            # App constants
│   │   ├── theme/                # App theming
│   │   └── utils/                # Utility functions
│   ├── features/                 # Feature-specific modules
│   │   ├── auth/                 # Authentication feature
│   │   ├── bom/                  # Bill of materials feature
│   │   │   ├── screens/          # BOM screens
│   │   │   └── widgets/          # BOM widgets
│   │   ├── dashboard/            # Dashboard feature
│   │   ├── purchases/            # Purchase management
│   │   └── shared/               # Shared components
│   ├── models/                   # Data models
│   │   ├── project.dart          # Project model
│   │   ├── project_model.dart    # Project model for PM view
│   │   ├── project_bom_model.dart # BOM model
│   │   ├── bill_of_materials.dart # BOM data model
│   │   ├── material_model.dart   # Material model
│   │   ├── material_movement.dart # Material movement tracking
│   │   ├── user_model.dart       # User model
│   │   ├── notification_model.dart # Notification model
│   │   ├── request_model.dart    # Request model
│   │   ├── audit_log_model.dart  # Audit logging
│   │   ├── bom_item_model.dart   # BOM item model
│   │   └── material_history_model.dart # Material history
│   ├── providers/                # State management providers
│   │   ├── user_provider.dart    # User state management
│   │   ├── project_provider.dart # Project state management
│   │   ├── projects_provider.dart # Projects list management
│   │   ├── notification_provider.dart # Notification state
│   │   └── bom_provider.dart     # BOM state management
│   ├── screens/                  # UI screens
│   │   ├── auth/                 # Authentication screens
│   │   ├── main/                 # Main app screens
│   │   ├── admin/                # Admin-specific screens
│   │   │   ├── project_details_screen.dart # Project details
│   │   │   └── projects/         # Project management
│   │   │       └── add_project_screen.dart # Add project
│   │   ├── bom/                  # BOM management screens
│   │   ├── dashboard/            # Dashboard screens
│   │   ├── pm_dashboard/         # Project manager dashboard
│   │   ├── users/                # User management
│   │   ├── purchases/            # Purchase management
│   │   ├── settings/             # Settings screens
│   │   ├── productivity/         # Productivity tracking
│   │   ├── reports/              # Reporting screens
│   │   └── approvals/            # Approval workflows
│   ├── services/                 # Service layer
│   │   ├── user_service.dart     # User management service
│   │   ├── bom_service.dart      # BOM management service
│   │   └── storage_service.dart  # File storage service
│   ├── utils/                    # Utility functions
│   │   ├── app_theme.dart        # App theme configuration
│   │   └── responsive.dart       # Responsive design utilities
│   ├── widgets/                  # Reusable widgets
│   │   ├── common/               # Common widgets
│   │   │   ├── alert_badge.dart  # Alert indicators
│   │   │   ├── activity_timeline.dart # Activity timeline
│   │   │   ├── info_card.dart    # Information cards
│   │   │   └── project_card.dart # Project display cards
│   │   └── dashboard/            # Dashboard-specific widgets
│   └── main.dart                 # Application entry point
├── docs/                         # Documentation
│   ├── admin/                    # Admin documentation
│   │   └── projects.md           # Project management guide
│   ├── project_manager/          # PM documentation
│   │   ├── dashboard.md          # PM dashboard guide
│   │   └── manager_bom.md        # BOM management guide
│   ├── PHASES_README.md          # Development phases
│   ├── rules.mdc                 # Development rules
│   ├── front_end_plan.md         # Frontend planning
│   └── main_layout.md            # Layout documentation
├── assets/                       # Static assets
│   └── images/                   # Image assets
├── firebase_reader.py            # Firebase data export script
├── create_indexes.py             # Firebase index creation script
├── firestore.rules               # Firestore security rules
├── cors.json                     # CORS configuration
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # This file
```

## 🔧 Setup & Installation

### 1. Flutter Environment Setup

Ensure you have Flutter installed and configured:

```bash
flutter doctor
```

### 2. Firebase Project Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable the following services:
   - Authentication
   - Firestore Database
   - Storage
   - Analytics

### 3. Firebase Configuration

Download and add your Firebase configuration files:

- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`
- **Web**: Add configuration to `web/index.html`

### 4. Service Account Setup

For Python scripts, download your Firebase service account key:
1. Go to Firebase Console → Project Settings → Service Accounts
2. Generate new private key
3. Save the JSON file securely

## 🔥 Firebase Configuration

### Firebase Reader Script

The `firebase_reader.py` script provides comprehensive data export functionality:

```bash
# Export all collections
python firebase_reader.py --creds path/to/serviceAccountKey.json

# Export specific collection
python firebase_reader.py --creds path/to/serviceAccountKey.json --collection users

# Export with filters
python firebase_reader.py --creds path/to/serviceAccountKey.json --collection movements --project-id project123

# Export with limit
python firebase_reader.py --creds path/to/serviceAccountKey.json --collection projects --limit 10
```

### Index Creation Script

The `create_indexes.py` script creates optimized Firestore indexes:

```bash
python create_indexes.py --creds path/to/serviceAccountKey.json
```

**Created Indexes:**
- `movements` collection: `projectId`, `materialId`, `performedBy`
- `billOfMaterials` collection: `status`, `projectId`
- `projects` collection: `status`, `managerId`
- `users` collection: `role`, `email`

### Firestore Security Rules

The `firestore.rules` file contains comprehensive security rules for:
- User authentication and authorization
- Role-based access control
- Data validation and sanitization
- Project and BOM access permissions

## 📦 Dependencies

### Flutter Dependencies

#### Core Firebase
```yaml
firebase_core: ^3.14.0      # Firebase core functionality
firebase_auth: ^5.6.0       # Authentication
cloud_firestore: ^5.6.9     # Database
firebase_storage: ^12.4.7   # File storage
firebase_analytics: ^11.5.0 # Analytics
```

#### State Management
```yaml
provider: ^6.1.1            # State management
```

#### UI & UX
```yaml
flutter_spinkit: ^5.2.0     # Loading animations
cached_network_image: ^3.3.1 # Image caching
flutter_svg: ^2.0.9         # SVG support
cupertino_icons: ^1.0.2     # iOS-style icons
```

#### Utilities
```yaml
image_picker: ^1.1.2        # Image selection
intl: ^0.20.2               # Internationalization
connectivity_plus: ^6.1.4   # Network connectivity
shared_preferences: ^2.5.3  # Local storage
path_provider: ^2.1.5       # File system access
uuid: ^4.5.1                # Unique identifiers
path: ^1.8.3                # Path manipulation
rxdart: ^0.28.0             # Reactive programming
flutter_image_compress: ^2.1.0 # Image compression
```

### Python Dependencies
```txt
firebase-admin>=6.2.0       # Firebase Admin SDK
```

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Analysis
```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format .

# Check for outdated dependencies
flutter pub outdated
```

## 📱 Deployment

### Android Deployment

1. **Update version in `pubspec.yaml`**
2. **Build release APK**
   ```bash
   flutter build apk --release
   ```
3. **Build app bundle for Play Store**
   ```bash
   flutter build appbundle --release
   ```

### iOS Deployment

1. **Update version in `pubspec.yaml`**
2. **Build for iOS**
   ```bash
   flutter build ios --release
   ```
3. **Archive in Xcode for App Store**

### Web Deployment

1. **Build for web**
   ```bash
   flutter build web --release
   ```
2. **Deploy to Firebase Hosting**
   ```bash
   firebase deploy --only hosting
   ```

## 🔧 Troubleshooting

### Common Issues

#### Firebase Configuration Issues
```bash
# Check Firebase configuration
flutter doctor
flutter pub get
flutter clean
flutter pub get
```

#### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### iOS Specific Issues
```bash
# Update iOS dependencies
cd ios
pod install
cd ..
flutter run
```

#### Android Specific Issues
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter run
```

#### Web Issues
```bash
# Clear web cache
flutter clean
flutter pub get
flutter run -d chrome --web-renderer html
```

### Performance Optimization

1. **Enable Flutter Performance Overlay**
   ```bash
   flutter run --profile
   ```

2. **Check for Memory Leaks**
   ```bash
   flutter run --profile --trace-startup
   ```

3. **Optimize Images**
   - Use `flutter_image_compress` for image optimization
   - Implement proper image caching strategies

### Debug Mode

For development and debugging:
```bash
# Run in debug mode with verbose logging
flutter run --verbose

# Enable debug prints
flutter run --debug
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Run tests and analysis**
   ```bash
   flutter test
   flutter analyze
   ```
5. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to your branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Development Guidelines

- Follow Flutter best practices and style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure code passes all linting rules
- Follow the project's responsive design principles
- Use the established project structure and naming conventions
- Implement proper error handling and loading states
- Use the Provider pattern for state management
- Follow the feature-based architecture

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check the [docs/](docs/) directory
- **Issues**: Create an issue on GitHub
- **Email**: [your-email@example.com]
- **Discord**: [Join our community]

## 🔄 Changelog

### Version 1.0.0 (Current)
- ✅ Firebase integration with real-time synchronization
- ✅ Role-based authentication system (Admin, Project Manager, User)
- ✅ Project management dashboard with multi-step creation forms
- ✅ Bill of Materials (BOM) management with material tracking
- ✅ Project Manager dashboard with assigned projects view
- ✅ Real-time notifications and low-stock alerts
- ✅ Cross-platform support (iOS, Android, Web)
- ✅ Offline capability with local storage
- ✅ Firebase data export and index creation scripts
- ✅ Comprehensive documentation and development guides
- ✅ Responsive design implementation for all screen sizes
- ✅ Clean architecture pattern with feature-based organization
- ✅ Enhanced project creation workflow with client details and budget tracking
- ✅ Standardized budget currency to ZAR (South African Rand)
- ✅ Material movement tracking (usage, transfers, returns, leftovers)
- ✅ Photo documentation for material verification
- ✅ Activity timeline and audit logging
- ✅ Search and filter functionality across projects and materials

### Upcoming Features
- 📊 Advanced analytics dashboard with charts and reports
- 📈 Enhanced reporting features with PDF/Excel export
- 🔧 Mobile app optimization for construction site use
- 🔗 Additional third-party integrations (accounting, scheduling)
- 🧪 Comprehensive automated testing suite
- ⚡ Performance optimization and caching improvements
- 📱 Progressive Web App (PWA) features for offline use
- 🔔 Enhanced notification system with push notifications
- 📋 Advanced approval workflows for material requests
- 🗺️ Project location mapping and GPS tracking
- 📱 Barcode/QR code scanning for material identification

## 🎯 Development Phases

For detailed information about development phases and roadmap, see [docs/PHASES_README.md](docs/PHASES_README.md).

## 📚 Additional Documentation

- **Frontend Plan**: [docs/front_end_plan.md](docs/front_end_plan.md)
- **Main Layout**: [docs/main_layout.md](docs/main_layout.md)
- **Development Rules**: [docs/rules.mdc](docs/rules.mdc)
- **Admin Documentation**: [docs/admin/](docs/admin/)
- **Project Manager Documentation**: [docs/project_manager/](docs/project_manager/)

---

<div align="center">
  <p>Built with ❤️ using Flutter and Firebase</p>
  <p>Made for construction professionals</p>
</div>
