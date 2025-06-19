# 🏗️ Abiezer Construction Management System (CMS)

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

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
- **Project Creation & Management** - Complete project lifecycle management
- **Timeline Tracking** - Milestone and deadline management
- **Team Assignment** - Assign and manage project teams
- **Document Management** - Store and organize project documents

### 📋 Bill of Materials (BOM)
- **Material List Management** - Comprehensive material tracking
- **Cost Estimation** - Real-time cost calculations and tracking
- **Inventory Management** - Stock level monitoring and alerts
- **Cost Analysis** - Detailed cost breakdown and reporting
- **Real-time Updates** - Live synchronization across all devices

### 💬 Communication & Collaboration
- **Real-time Chat** - Instant messaging between team members
- **In-app Notifications** - Push notifications for important updates
- **Image Sharing** - Photo documentation and sharing
- **Team Collaboration** - Enhanced team coordination tools

### 📱 Cross-Platform Support
- **iOS & Android** - Native mobile applications
- **Web Support** - Progressive Web App (PWA)
- **Offline Capability** - Work without internet connection
- **Responsive Design** - Optimized for all screen sizes

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

3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure Firebase** (see [Firebase Configuration](#-firebase-configuration))

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots

*Screenshots will be added here showing the main features of the application*

## 🏗️ Architecture

The application follows a clean architecture pattern with the following layers:

- **Presentation Layer** - UI screens and widgets
- **Business Logic Layer** - Providers and state management
- **Data Layer** - Services and models
- **Infrastructure Layer** - Firebase integration and utilities

### State Management
- **Provider Pattern** - For state management across the app
- **Firebase Real-time Updates** - Live data synchronization
- **Local Storage** - Offline data persistence

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
│   │   ├── projects/             # Project management
│   │   ├── bom/                  # Bill of materials
│   │   └── chat/                 # Communication
│   ├── models/                   # Data models
│   ├── providers/                # State management providers
│   ├── screens/                  # UI screens
│   │   ├── auth/                 # Authentication screens
│   │   ├── main/                 # Main app screens
│   │   ├── admin/                # Admin-specific screens
│   │   └── project_manager/      # PM-specific screens
│   ├── services/                 # Service layer
│   │   ├── firebase/             # Firebase services
│   │   ├── api/                  # API services
│   │   └── storage/              # Local storage
│   ├── utils/                    # Utility functions
│   ├── widgets/                  # Reusable widgets
│   └── main.dart                 # Application entry point
├── docs/                         # Documentation
│   ├── admin/                    # Admin documentation
│   ├── project_manager/          # PM documentation
│   └── PHASES_README.md          # Development phases
├── firebase_reader.py            # Firebase data export script
├── create_indexes.py             # Firebase index creation script
├── pubspec.yaml                  # Flutter dependencies
├── requirements.txt              # Python dependencies
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

## 📦 Dependencies

### Flutter Dependencies

#### Core Firebase
```yaml
firebase_core: ^2.24.2      # Firebase core functionality
firebase_auth: ^4.16.0      # Authentication
cloud_firestore: ^4.14.0    # Database
firebase_storage: ^11.6.0   # File storage
firebase_analytics: ^10.8.6 # Analytics
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
intl: ^0.19.0               # Internationalization
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
- ✅ Role-based authentication system
- ✅ Project management dashboard
- ✅ Bill of Materials (BOM) management
- ✅ Real-time chat and notifications
- ✅ Cross-platform support (iOS, Android, Web)
- ✅ Offline capability
- ✅ Firebase data export scripts
- ✅ Comprehensive documentation

### Upcoming Features
- 📊 Advanced analytics dashboard
- 📈 Enhanced reporting features
- 🔧 Mobile app optimization
- 🔗 Additional third-party integrations
- 🧪 Automated testing suite
- ⚡ Performance optimization

---

<div align="center">
  <p>Built with ❤️ using Flutter and Firebase</p>
  <p>Made for construction professionals</p>
</div>
