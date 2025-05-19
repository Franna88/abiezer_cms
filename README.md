# Abiezer Construction CMS

A comprehensive construction materials management system built with Flutter.

## Overview

Abiezer Construction CMS is a powerful materials management solution designed specifically for construction companies. It helps project managers and site supervisors track materials, manage inventory, handle material requests, transfers, and returns, and reduce waste across multiple construction projects.

## Key Features

- **Project Management**: Create, track, and manage multiple construction projects
- **Bill of Materials (BoM)**: Comprehensive tracking of all materials needed for each project
- **Materials Request System**: Request, approve, and track materials for projects
- **Material Transfer Workflow**: Transfer materials between projects with approval tracking
- **Material Return Management**: Process and track returned unused or damaged materials
- **Inventory Management**: Monitor stock levels with customizable low-stock alerts
- **Purchase Tracking**: Track material purchases and expenditures
- **Historical Data**: View project and material history for audit and analysis
- **Responsive Design**: Works seamlessly across mobile, tablet, and desktop
- **Role-Based Access**: Different interfaces and permissions for admins and project managers

## Getting Started

### Prerequisites

- Flutter SDK (v3.7.2 or higher)
- Dart SDK (v3.7.2 or higher)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/barefootbyte/abiezer_cms.git
   cd abiezer_cms
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── models/          # Data models (project, material, user, etc.)
│   ├── theme/           # App theming (colors, text styles)
│   └── utilities/       # Helper functions and constants
├── features/            # Feature-based modules
│   ├── auth/            # Authentication screens
│   ├── dashboard/       # Main dashboard
│   ├── bom/             # Bill of Materials management
│   │   ├── pages/       # BoM sub-pages (requests, inventory, etc.)
│   │   └── widgets/     # BoM-specific widgets
│   ├── projects/        # Project management
│   ├── purchases/       # Purchase tracking
│   └── reports/         # Reports and analytics
├── widgets/             # Reusable UI components
│   ├── common/          # Shared widgets
│   └── ...
└── main.dart            # App entry point
```

## Features in Detail

### Bill of Materials (BoM) Management

The BoM system is organized into four main sections:

1. **Requests**
   - Review and manage material requests from projects
   - Approve or deny requests with comments
   - Track request history and status

2. **Shopping List**
   - View and manage materials needed for projects
   - Track quantities and costs
   - Generate purchase orders

3. **Material Inventory**
   - Browse and manage all project materials
   - Track stock levels and locations
   - Update material information

4. **Low Stock & Out of Stock**
   - Monitor inventory levels
   - Set up alerts for low stock items
   - Manage reorder points

### Project Management

- Create and manage construction projects
- Assign project managers and team members
- Track project status and progress
- Manage project-specific materials and resources

### Material Management

- Track material usage across projects
- Manage material transfers between projects
- Process material returns
- Monitor material costs and budgets

## User Roles and Permissions

### Admin
- Full access to all features and projects
- Manage user roles and permissions
- Oversee all material requests and transfers
- Access comprehensive reports and analytics

### Project Manager
- Access to assigned projects
- Create and manage project BoMs
- Request materials and transfers
- Generate project-specific reports

## Technical Implementation

### State Management
- Uses Flutter's built-in state management
- Implements responsive design patterns
- Follows Material Design guidelines

### Dependencies
- `intl`: ^0.20.2 - For internationalization and formatting
- `uuid`: ^4.5.1 - For generating unique identifiers
- `cupertino_icons`: ^1.0.8 - For iOS-style icons
- `flutter_lints`: ^5.0.0 - For code quality

### Responsive Design
- Mobile-first approach
- Adaptive layouts for different screen sizes
- Consistent UI across platforms

## Development Guidelines

### Code Style
- Follow Flutter's official style guide
- Use meaningful variable and function names
- Document complex logic and functions
- Keep widgets small and focused

### Testing
- Write unit tests for business logic
- Implement widget tests for UI components
- Test on multiple screen sizes
- Verify all user flows

### Performance
- Optimize widget rebuilds
- Use const constructors where possible
- Implement lazy loading for large lists
- Cache frequently accessed data

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@abiezer.com or create an issue in the repository.

---

Developed with ❤️ by BarefootByte
