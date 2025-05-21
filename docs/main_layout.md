# Abiezer Construction Reworked Front-End Main Layout

## 1. Overview
This document outlines the reworked main layout for the Abiezer Construction app’s front end, built with Flutter for web, iOS, Android, and tablet. The layout supports Admin and onsite Project Manager roles with a responsive sidebar navigation (sidenav), top bar, and main content area, tailored to their specific responsibilities.

## 2. Role Definitions
### 2.1 Admin
- Full access to all projects, materials, purchases, approvals, and reporting.
- Manages material catalog, user permissions, and project assignments.
- Approves material requests, transfers, returns, and purchases.
- Generates company-wide reports and monitors audit trails.

### 2.2 Project Manager (Onsite)
- Access limited to assigned projects (current and past).
- Logs material usage, requests additional materials, logs returns, and logs leftover materials.
- Views personal productivity reports (assigned projects, past projects, usage logs).
- Actions require admin approval (requests, transfers, returns).

## 3. Layout Structure
### 3.1 Sidenav (Left Navigation)
- **Purpose**: Navigation for core modules and role-specific actions.
- **Behavior**:
  - Web/Tablet: Persistent sidenav (250px wide) with icons and labels.
  - Mobile: Collapsible hamburger menu via top bar.
  - Active tab highlighted with blue background.
- **Admin Tabs**:
  - **Dashboard**: All projects overview, low-stock alerts, pending requests.
  - **Projects**: Create, manage, and monitor projects (details, BoM, requests, history).
  - **Bill of Materials (BoM)**: Manage catalog and project BoMs (edit, allocate, thresholds).
  - **Purchases**: Approve/log purchases, manage payment proofs.
  - **Approvals**: Review material requests, transfers, returns, purchases.
  - **Reports**: Generate BoM, usage, cost, audit reports (PDF/Excel).
  - **Users**: Manage roles, project assignments, permissions.
  - **Settings**: Profile, notifications, logout.
- **Project Manager Tabs**:
  - **Dashboard**: Assigned projects overview, low-stock alerts, request statuses.
  - **Bill of Materials (BoM)**: View BoM, log usage, request materials, initiate transfers/returns.
  - **Purchases**: Log purchase requests, view statuses.
  - **My Productivity**: View assigned/past projects, usage logs.
  - **Settings**: Profile, notifications, logout.
- **Design**:
  - Icons: Home (Dashboard), Folder (Projects), Clipboard (BoM), Cart (Purchases), Checkmark (Approvals), Chart (Reports/Productivity), Users (Users), Gear (Settings).
  - Role-based visibility: Hide Projects, Approvals, Reports, Users for Project Managers.

### 3.2 Top Bar
- **Elements**:
  - **Project Selector**: Dropdown for active project.
    - Admin: All projects.
    - Project Manager: Assigned projects only.
  - **User Info**: “{Username} - {Role}” (e.g., “Jane Smith - Project Manager”).
  - **Notifications Icon**: Badge with count (e.g., “2” for alerts).
  - **Hamburger Menu (mobile)**: Toggles sidenav.
- **Behavior**:
  - Sticky, full-width, 60px height.
  - Project selection mandatory; refreshes tab content.
  - Notifications open popover with actionable alerts.
- **Design**:
  - White background, subtle shadow.
  - Wide, touch-friendly project selector.
  - Red notification badge for urgency.

### 3.3 Main Content Area
- **Purpose**: Displays tab content (e.g., BoM table, purchase form).
- **Behavior**:
  - Responsive: Single-column (mobile), multi-column (web/tablet).
  - Updates based on project and role.
  - Large, touch-friendly buttons for onsite use.
  - Loading indicators for Firebase sync.
- **Design**:
  - Cards for lists, forms for inputs.
  - Padding: 16px (mobile), 24px (web/tablet).
  - Clear error messages (e.g., “Select a project”).

### 3.4 Footer (Optional)
- **Content**: Version (e.g., “v1.0.0”), support contact.
- **Behavior**: Hidden on mobile.
- **Design**: Gray, 40px height.

## 4. Technical Notes
- **Flutter Widgets**:
  - `Scaffold`: Layout with `AppBar`, `Drawer` (mobile), `NavigationRail` (web/tablet).
  - `ListView`/`GridView`: Responsive content area.
  - `DropdownButton`: Role-filtered project selector.
- **State Management**: Provider for project, role, notification state.
- **Routing**: Named routes with role-based access control.
- **Responsive Design**: `MediaQuery`/`LayoutBuilder` for layout adjustments.
- **Firebase**:
  - Firestore: Project lists, BoM data, notifications.
  - Cloud Storage: Photo uploads.
  - Real-time listeners: Low stock, request statuses.

## 5. Next Steps
- Create Figma wireframes for Admin and Project Manager tabs.
- Prototype project selector and notifications in Flutter.
- Validate layout with stakeholders, focusing on onsite usability.
- Plan tab-specific structure (e.g., Projects, BoM, Purchases) next.