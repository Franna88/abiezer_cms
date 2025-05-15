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
- **Responsive Design**: Works seamlessly across mobile, tablet, and desktop
- **Role-Based Access**: Different interfaces and permissions for admins and project managers

## Getting Started

### Prerequisites

- Flutter SDK (v3.7.2 or higher)
- Dart SDK (v3.0.0 or higher)
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
│   ├── models/           # Data models (project, material, user, etc.)
│   ├── theme/            # App theming (colors, text styles)
│   └── utilities/        # Helper functions and constants
├── features/             # Feature-based modules
│   ├── auth/             # Authentication screens
│   ├── dashboard/        # Main dashboard
│   ├── bom/              # Bill of Materials management
│   ├── projects/         # Project management
│   └── reports/          # Reports and analytics
├── widgets/              # Reusable UI components
│   ├── common/           # Shared widgets
│   └── ...
└── main.dart             # App entry point
```

## Administrative Workflow

### Admin Dashboard

The admin dashboard provides a comprehensive view of:
- All active projects with status indicators
- Pending material requests, transfers, and returns
- Low-stock alerts across all projects
- Quick access to BoM management and user management

### Project Management

Administrators can:
- Create and manage all construction projects
- Assign project managers to specific projects
- Update project status (active, completed, pending, canceled)
- Edit project details (location, client information, dates)
- View detailed project statistics and material usage

### Bill of Materials Management

Admins have complete control over the BoM system:
- View and edit the full BoM for any project
- Adjust material allocations manually
- Correct usage logs and quantity entries
- Set low-stock thresholds for each material
- Manage the master material catalog (add, edit, categorize)

### Material Request Processing

The admin reviews and handles all material requests:
- Review material details, quantity, reason, and attachments
- Approve, deny, or adjust requested quantities
- Add comments explaining decisions
- System automatically updates BoMs upon approval

### Material Transfer and Returns

Admins oversee material transfers between projects:
- Review source/destination projects, material quantity, and reason
- Approve or deny transfer requests
- Manage the return of unused or damaged materials
- Coordinate disposal or restocking of returned materials

## Project Manager Workflow

Project managers have a focused view of their assigned projects:
- View and manage their assigned projects
- Mark materials as used in the construction process
- Request additional materials when needed
- Transfer materials between their assigned projects
- Generate reports for their specific projects

## Data Models

### Projects

Projects are the central entity in the system. Each project contains:
- Basic details (name, description, location)
- Client information
- Start and end dates
- Status (active, completed, pending, canceled)
- Assigned users and project manager

### Bill of Materials (BoM)

Each project has a Bill of Materials which includes:
- List of materials needed for the project
- Quantity required for each material
- Usage tracking
- Total cost calculation

### Materials

Materials represent construction supplies with:
- Name and description
- Category (from predefined list)
- Unit of measure
- Unit price
- Stock status
- Source (new, leftover)

### Users

The system supports different user roles:
- **Admin**: Full access to all features and projects
- **Project Manager**: Access to assigned projects with specific permissions

## Responsive Design

The app is built with a fully responsive design approach:
- **Mobile**: Compact interface with drawer navigation
- **Tablet**: Split view with side navigation and content
- **Desktop**: Expanded view with full sidebar and detailed content

All UI components adapt to different screen sizes using:
- `MediaQuery` for screen-aware layouts
- `LayoutBuilder` for constraint-based widgets
- Flexible and Expanded widgets for proportional sizing

## Color Scheme

The app follows a consistent color scheme:
- **Primary Color**: Dark Blue (`#2E3853`)
- **Secondary Color**: Light Blue (`#2577CC`)
- **Accent Color**: Green (`#B9CC25`)
- **Error Color**: Red (`#CF2419`)
- **Background**: Light Gray (`#F5F5F7`)
- **Card Background**: White (`#FEFFFE`)

## Technologies Used

- **Flutter**: Cross-platform UI framework (^3.7.2)
- **Dart**: Programming language (^3.7.2)
- **intl**: Internationalization and formatting (^0.20.2)
- **uuid**: Generating unique identifiers (^4.5.1)
- **cupertino_icons**: iOS style icons (^1.0.8)
- **flutter_lints**: Code quality (^5.0.0)

## Development Guidelines

### Responsive Design Implementation

When adding new screens:
1. Use `MediaQuery` or `LayoutBuilder` to detect screen size
2. Implement different layouts for mobile, tablet, and desktop
3. Avoid fixed dimensions - use relative sizing with Flexible/Expanded
4. Test on multiple screen sizes before committing changes

### Code Organization

When adding new features:
1. Place feature-specific code in the appropriate `/features` subdirectory
2. Extract reusable widgets to the `/widgets` directory
3. Keep feature-specific models with the feature
4. Move broadly used models to `/core/models`

## Future Enhancements

Planned future enhancements include:
- Material forecasting and optimization
- Advanced reporting and analytics
- Supplier management and ordering system
- Mobile barcode/QR code scanning for inventory
- Offline mode for site usage
- Multi-language support
- Cloud synchronization

## Contributing

We welcome contributions to improve Abiezer Construction CMS:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For support or inquiries, please contact [support@barefootbyte.dev](mailto:support@barefootbyte.dev).

---

Developed with ❤️ by BarefootByte
