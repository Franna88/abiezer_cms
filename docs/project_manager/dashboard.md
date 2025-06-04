# Abiezer Construction Project Manager Dashboard Plan

## 1. Overview
The Project Manager Dashboard provides an overview of assigned projects, low-stock alerts, pending requests, and notifications, optimized for tablet and mobile use with Flutter. It's touch-friendly, single-column (mobile) or two-column (tablet), and designed for onsite construction environments.

## 2. Requirements
- List assigned projects: Name, location, BoM status, links.
- Show pending requests: Material, transfer, return, purchase with statuses.
- Display notifications: Low stock, request updates, actionable.
- Show metrics: Total projects, low-stock materials.
- Touch-friendly, high-contrast, offline support.

## 3. Workflow
1. Log in; land on Dashboard.
2. Scroll project cards; tap "View BoM" to navigate.
3. Search by name; filter by status (Active, Completed).
4. View request cards; tap for details.
5. Scroll notifications; tap for actions.
6. Review metrics; tap to filter projects.
7. Navigate via hamburger menu.

## 4. UI Components
- Header: "Dashboard" title in `AppBar`.
- Projects: `ListView` (mobile) or `GridView` (tablet) with `Card`.
- Requests/Notifications: `ListView` with `Card`.
- Metrics: Text at top.
- Search/Filter: `TextField` (collapsible), `DropdownButton`.
- Buttons: `ElevatedButton` (48px min.).

## 5. Features
Below are the features of the Project Manager Dashboard with detailed usage/UX examples.

- **Projects**:
  - **Description**: Displays cards for assigned projects with name, location, BoM status, and a "View BoM" button.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Project Manager John Doe logs in on his tablet at a construction site. He sees cards: "Project X, Site A, BoM Created, View BoM," "Project Z, Site C, BoM Created, View BoM." He taps "View BoM" on Project X, navigating to the BoM tab to log material usage.
- **Pending Requests**:
  - **Description**: Shows pending requests (material, transfer, return, purchase) with type, material, quantity, and status.
  - **Usage/UX Example**: John sees a card: "Material Request, Cement, 50 bags, Pending." He taps it to view details: "Requested on 2025-05-18, Reason: Urgent need." He waits for Admin approval, receiving a notification later: "Request approved, 2025-05-19 02:55 PM."
- **Notifications**:
  - **Description**: Displays alerts for low stock or request updates with actionable buttons.
  - **Usage/UX Example**: A notification appears: "Low Stock: Cement in Project X, 40 remaining, 2025-05-19 02:54 PM." John taps it, navigating to the BoM tab, where he requests more Cement by filling out a form and uploading a photo of the site.
- **Metrics**:
  - **Description**: Shows total assigned projects and low-stock materials, with tappable links to filter projects.
  - **Usage/UX Example**: The header shows "2 Assigned Projects, 1 Low-Stock Material." John taps "1 Low-Stock Material," and the project cards filter to show only Project X, which has low Cement stock.

## 6. Technical Details
- **Flutter Widgets**:
  - `Scaffold`, `AppBar`, `ListView`, `GridView`, `Card`.
  - `TextField`, `DropdownButton`, `ElevatedButton`.
  - `RefreshIndicator` for swipe-to-refresh.
- **Firebase**:
  - `projects`: Query by `project_manager`.
  - `requests`: User's requests.
  - `notifications`: Alerts.
  - Listeners: Stream data.
  - Offline: Cache projects.
- **State Management**: Provider for data/filters.
- **Responsive**: Single-column mobile; two-column tablet (>600px).
- **Usability**: Haptic feedback, high-contrast, swipe-to-refresh.
- **Error Handling**: Show "No projects" or network errors.

## 7. Development Steps
1. Wireframe in Figma for tablet/mobile.
2. Create `PMDashboardScreen` with `Scaffold`.
3. Set up Firestore queries/listeners.
4. Build cards, search, filter, metrics.
5. Add interactivity: Navigation, actions.
6. Test on tablet/mobile, offline mode.
7. Deploy to beta; monitor with Crashlytics.

## 8. Next Steps
- Finalize wireframe.
- Test Firebase offline support.
- Plan BoM tab. 