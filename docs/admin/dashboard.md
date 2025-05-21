# Abiezer Construction Admin Dashboard Plan

## 1. Overview
The Admin Dashboard is the central hub for Admins in the Abiezer Construction app, built with Flutter for web, iOS, Android, and tablet. It provides a high-level overview of all projects, pending requests, notifications, and key metrics, enabling Admins to monitor operations and navigate to other tabs for detailed management.

## 2. Requirements
- **Project Overview**: List all active projects with name, location, Project Manager, BoM status, and quick links.
- **Pending Actions**: Show counts and summaries of material requests, transfers, returns, and purchases; link to Approvals tab.
- **Notifications**: Display real-time alerts for low stock, new requests, and system updates with actionable buttons.
- **Quick Metrics**: Summarize total projects, low-stock materials, and recent activity.
- **Navigation**: Easy access to Projects, BoM, Purchases, Approvals, Reports, Users, Settings.
- **Usability**: Responsive, touch-friendly design for construction environments.
- **Role-Based**: Admin-only, with full access to all projects and data.

## 3. Workflow
1. **Login**: Admin logs in and lands on Dashboard.
2. **View Projects**:
   - See grid/list of projects with name, location, Project Manager, BoM status.
   - Filter by status (All, Active, Completed) or search by name.
   - Tap “View Details” to navigate to Projects tab.
3. **Monitor Pending Actions**:
   - View counts (e.g., “3 Material Requests”) and summaries.
   - Tap “Review” to navigate to Approvals tab.
4. **Handle Notifications**:
   - See alerts (e.g., “Cement low, Project Y”).
   - Tap to take action (e.g., request material, review request).
5. **Review Metrics**:
   - See total projects, low-stock materials, recent activity.
   - Tap metrics to drill down (e.g., low-stock projects).
6. **Navigate**: Use sidenav or links to other tabs.
7. **Logout/Switch**: Log out or select project for detailed actions.

## 4. UI Components
- **Header**:
  - Title: “Admin Dashboard”.
  - Refresh button for data sync.
  - Metrics: “{X} Active Projects,” “{Y} Low-Stock Materials”.
- **Projects Grid**:
  - Cards with project name, location, Project Manager, BoM status.
  - Button: “View Details” (navigates to Projects tab).
  - Filters: Status dropdown (All, Active, Completed).
  - Search bar for project name.
- **Pending Actions Panel**:
  - Collapsible cards for Material Requests, Transfers, Returns, Purchases.
  - Shows count and summaries (e.g., “Cement, 50 bags, Project X”).
  - Button: “Review” (navigates to Approvals).
- **Notifications Feed**:
  - List of alerts with timestamp and action button (e.g., “Request Material”).
- **Recent Activity Log**:
  - Timeline of last 5-10 actions (e.g., “Usage logged, Project Z, 10:00 AM”).
  - Clickable to view details.

## 5. Features
Below are the features of the Admin Dashboard with detailed usage/UX examples.

- **Projects**:
  - **Description**: Displays a grid or list of all projects (active, completed, or archived) with key details like name, location, assigned Project Manager, and BoM status (e.g., “BoM Created” or “Not Started”).
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Alice logs in on her tablet. She sees a grid with “Project X, Site A, John Doe, BoM Created” and “Project Y, Site B, Jane Smith, Not Started.” She searches for “Project X” using the search bar, and the grid filters to show only Project X. She taps “View Details” on Project X, navigating to the Projects tab to manage its BoM.
- **Pending Actions**:
  - **Description**: Shows counts and summaries of pending material requests, transfers, returns, and purchases in collapsible cards, with a “Review” button linking to the Approvals tab.
  - **Usage/UX Example**: Alice notices a card labeled “Material Requests: 3 Pending.” She expands it and sees “Cement, 50 bags, Project X, Requested by John Doe, 2025-05-18.” She taps “Review,” which takes her to the Approvals tab, where she can approve or deny the request.
- **Notifications**:
  - **Description**: Displays real-time alerts for low stock, new requests, or system updates, with actionable buttons (e.g., “Request Material” or “Review Request”).
  - **Usage/UX Example**: A notification pops up: “Low Stock: Cement in Project X, 10 bags remaining, 2025-05-19 02:50 PM.” Alice taps “Request Material,” which navigates to the Purchases tab with a pre-filled form for Cement in Project X, allowing her to request 50 more bags.
- **Quick Metrics**:
  - **Description**: Summarizes key stats like total projects, low-stock materials, and recent activity, with tappable links to filter related data.
  - **Usage/UX Example**: The header shows “5 Active Projects, 2 Low-Stock Materials.” Alice taps “2 Low-Stock Materials,” and the Projects grid filters to show only projects with low-stock materials (e.g., Project X and Project Z). She taps Project X to investigate further.
- **Navigation**:
  - **Description**: Provides sidenav links to other tabs (Projects, BoM, etc.) for quick access.
  - **Usage/UX Example**: After reviewing notifications, Alice taps the “Projects” tab in the sidenav to create a new project, seamlessly navigating to the Projects tab.

## 6. Technical Details
- **Flutter Widgets**:
  - `Scaffold`: Wraps Dashboard with top bar and sidenav.
  - `AppBar`: Title, refresh button.
  - `GridView`/`ListView`: Project cards.
  - `ExpansionTile`: Pending actions cards.
  - `ListTile`: Notifications, activity log.
  - `TextField`: Search bar.
  - `DropdownButton`: Status filter.
- **State Management**: Provider for projects, requests, notifications.
- **Firebase**:
  - **Firestore**:
    - `projects`: Fetch all projects (`name`, `location`, `project_manager`, `bom_status`).
    - `requests`: Fetch pending requests by type.
    - `notifications`: Fetch Admin alerts, sorted by timestamp.
    - `audit_log`: Fetch recent actions (limit 10).
  - **Real-Time Listeners**: Stream projects, requests, notifications.
- **Responsive Design**: `MediaQuery` for grid columns (1 mobile, 3 web).
- **Error Handling**: Show errors for failed loads; use Firebase offline persistence.

## 7. Development Steps
1. **Wireframe**: Create Figma wireframe for Dashboard; validate with stakeholders.
2. **Flutter Setup**: Create `AdminDashboardScreen`; add `Scaffold`, top bar, sidenav.
3. **Firebase Integration**: Set up Firestore queries and listeners for projects, requests, notifications, activity.
4. **Build UI**:
   - Project grid with filters/search.
   - Pending actions with `ExpansionTile`.
   - Notifications feed with action buttons.
   - Activity timeline with `ListTile`.
5. **Add Interactivity**: Link buttons to Projects/Approvals tabs; handle refresh.
6. **Test**:
   - Test responsiveness on web, mobile, tablet.
   - Simulate alerts/requests for accuracy.
   - Usability testing with Admins.
7. **Deploy**: Beta deploy to TestFlight/Google Play Beta; monitor with Crashlytics.

## 8. Next Steps
- Finalize Dashboard wireframe in Figma.
- Implement Firebase queries and test data syncing.
- Plan next tab (e.g., Projects) for Admin view.