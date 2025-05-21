# Abiezer Construction Admin Projects Tab Plan

## 1. Overview

The Projects Tab enables Admins to create, manage, and monitor projects in the Abiezer Construction app, built with Flutter for web, iOS, Android, and tablet. It centralizes project management, including details, Bill of Materials (BoM), requests, history, and analytics, with a responsive, touch-friendly interface for Admin use.

## 2. Requirements

- Create projects: Name, location, start/end dates, status.
- Assign Project Managers: Assign one or multiple Project Managers.
- Manage project details: Edit name, location, dates, status; archive/delete projects.
- Manage BoM: Create, edit, view history of project materials.
- View requests: Material, transfer, return, purchase requests with statuses.
- View history: Audit trail of project actions (creation, BoM changes, requests).
- Analytics: Project cost tracking, material usage trends.
- Search/filter projects by name, status, or Project Manager.
- Display low-stock alerts and pending actions for projects.
- Responsive, touch-friendly design with offline support.

## 3. Workflow

1. **Navigate to Projects Tab**:
   - Admin selects “Projects” from sidenav.
   - Views list of projects (Name, Location, Status, Project Managers).
2. **Search/Filter Projects**:
   - Search by name or filter by status/Project Manager.
3. **Create Project**:
   - Click “Create Project”.
   - Fill form: Name, Location, Start/End Dates, Status.
   - Select Project Managers.
   - Submit; project appears in list.
4. **View/Edit Project**:
   - Click “View/Edit” on a project.
   - **Details Sub-Tab**:
     - Edit name, location, dates, status.
     - Reassign Project Managers.
     - Archive/delete project (with confirmation).
   - **Bill of Materials Sub-Tab**:
     - Create BoM if none exists: Select materials, set quantities.
     - Edit BoM: Add/remove materials, adjust quantities.
     - View history: Usage logs, adjustments.
     - Request more for low-stock items (links to Purchases).
   - **Requests Sub-Tab**:
     - View requests (e.g., “Material Request, Cement, Pending”).
     - Click “Review” to navigate to Approvals.
   - **History Sub-Tab**:
     - View timeline: “BoM created”, “Cement requested”.
     - Filter by action type.
   - **Analytics Sub-Tab**:
     - View cost tracking: Total material costs, purchase history.
     - View material usage trends: Usage rates, frequent materials.
     - Export data as PDF/Excel.
5. **Navigate**:
   - Return to project list or switch tabs (e.g., Approvals, Purchases).

## 4. UI Components

- **Project List**:
  - Header: “Projects” title, “Create Project” button.
  - Table/List: Name, Location, Status, Project Managers, Actions (View/Edit, Archive).
  - Search: `TextField` for name.
  - Filter: `DropdownButton` for status/Project Manager.
- **Detail View**:
  - Sub-Tabs: Details, Bill of Materials, Requests, History, Analytics.
  - **Details**:
    - Form: Name, location, dates, status.
    - Multi-select: Project Managers.
    - Buttons: “Save”, “Archive Project”, “Delete Project”.
  - **Bill of Materials**:
    - Table: Name, Category, Unit, Total, Used, Remaining, Low-Stock.
    - Buttons: “Create BoM”, “Add Material”, “Edit Material”, “View History”.
    - Forms: Add/edit materials.
  - **Requests**:
    - List: Type, Material, Quantity, Status, Requester, Date.
    - Button: “Review” (links to Approvals).
  - **History**:
    - Timeline: Audit trail entries.
    - Filter: By action type.
  - **Analytics**:
    - Cost Tracking: Table with material costs, purchase costs, total cost.
    - Material Usage Trends: Charts for usage rates, frequent materials.
    - Export: Buttons for PDF/Excel.
- **Responsive**:
  - Web/Tablet: Multi-column tables, side-by-side forms.
  - Mobile: Single-column, stacked forms, collapsible search/filter.

## 5. Features

Below are the features of the Projects Tab with detailed usage/UX examples for each.

- **Project Creation**:
  - **Description**: Allows Admins to create new projects by filling out a form with project details (name, location, start/end dates, status) and assigning Project Managers.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Bob taps “Create Project” on his web browser. He fills the form: Name (“Project Z”), Location (“Site C”), Start Date (2025-06-01), End Date (2025-12-01), Status (“Active”). He selects Project Managers John Doe and Jane Smith from a multi-select dropdown. After tapping “Submit,” Project Z appears in the project list, and an audit log entry is created: “Project Z created by Admin Bob, 2025-05-19 02:54 PM.”
- **Project Management**:
  - **Description**: Admins can edit project details, reassign Project Managers, or archive/delete projects with confirmation dialogs.
  - **Usage/UX Example**: Bob clicks “View/Edit” on Project X. In the Details sub-tab, he updates the End Date to 2025-11-30 and removes Jane Smith as a Project Manager, leaving John Doe. He taps “Save,” and the changes are reflected immediately with an audit log: “Updated Project X details by Admin Bob, 2025-05-19 02:55 PM.” Later, he archives Project Y by tapping “Archive Project,” confirming the action in a dialog, and Project Y moves to the “Archived” status.
- **Bill of Materials**:
  - **Description**: Admins can create a BoM for a project by selecting materials from the Master Catalog and setting quantities, edit the BoM by adding/removing materials or adjusting quantities, view usage history, and handle low-stock alerts.
  - **Usage/UX Example**: Bob navigates to Project X’s Bill of Materials sub-tab on his tablet. No BoM exists, so he taps “Create BoM.” He selects “Cement” from the Master Catalog, sets the quantity to 100 bags, and adds “Plywood” with 50 sheets. After submitting, the BoM table shows: Cement (100 total, 0 used, 100 remaining). Later, he sees Cement usage logged by John Doe (50 bags used, 50 remaining, threshold 20), triggering a low-stock alert. Bob taps “Request More,” navigating to the Purchases tab with a pre-filled form for 50 more bags of Cement.
- **Requests**:
  - **Description**: Displays a list of project-specific requests (material, transfer, return, purchase) with details like type, material, quantity, status, requester, and date, with a “Review” button linking to Approvals.
  - **Usage/UX Example**: In Project X’s Requests sub-tab, Bob sees a list: “Material Request, Cement, 50 bags, Pending, John Doe, 2025-05-18.” He taps “Review,” which navigates to the Approvals tab, where he approves the request, adding a comment: “Approved for urgent delivery.” John Doe receives a notification: “Request approved, 2025-05-19 02:56 PM.”
- **History**:
  - **Description**: Shows a timeline of project actions (e.g., creation, BoM changes, requests) with filtering by action type.
  - **Usage/UX Example**: Bob opens the History sub-tab for Project X. He sees a timeline: “Project created by Admin Alice, 2025-05-01,” “BoM created by Admin Bob, 2025-05-19,” “Cement requested by John Doe, 2025-05-18.” He filters by “BoM Changes” to see only BoM-related actions, focusing on material adjustments.
- **Analytics**:
  - **Description**: Provides project cost tracking (material and purchase costs) and material usage trends (usage rates, frequent materials) with export options (PDF/Excel).
  - **Usage/UX Example**: In the Analytics sub-tab for Project X, Bob sees a table: “Total Material Cost: $1,050 (Cement: $500, Plywood: $550)” and “Total Purchase Cost: $600.” A line chart shows Cement usage increasing over the past month. He taps “Export to PDF,” generating a report titled “Project X Analytics - 2025-05-19,” which he emails to his boss.
- **Search/Filter**:
  - **Description**: Allows searching projects by name and filtering by status or Project Manager.
  - **Usage/UX Example**: Bob types “Project X” in the search bar, and the project list filters to show only Project X. He then filters by “Active” status, seeing all active projects, or filters by Project Manager “John Doe” to see only John’s projects.
- **Notifications**:
  - **Description**: Displays low-stock alerts and pending actions for the project, with actionable buttons.
  - **Usage/UX Example**: A notification appears on Project X: “Low Stock: Cement, 50 remaining, below threshold 20.” Bob taps the notification, which takes him to the Bill of Materials sub-tab, where he requests more Cement via the “Request More” button.

## 6. Technical Details

- **Flutter Widgets**:
  - `Scaffold`: Tab layout.
  - `DataTable`/`ListView`: Project list.
  - `TabBar`: Sub-tabs.
  - `Form`, `TextField`, `DropdownButton`, `MultiSelect`: Inputs.
  - `ListTile`: Requests, history.
  - `Charts`: Usage trend visualizations.
  - `ElevatedButton`: Actions (min. 48px).
- **Firebase**:
  - `projects`: Project data (`name`, `location`, `start_date`, `end_date`, `status`, `project_managers`).
  - `projects/{projectId}/bom`: BoM data.
  - `projects/{projectId}/requests`: Requests.
  - `projects/{projectId}/audit_log`: Audit trail.
  - `purchases`: Purchase data for cost tracking.
  - `users`: Fetch Project Managers.
  - Listeners: Stream `projects`, `bom`, `requests`, `audit_log`.
- **State Management**: Provider for data, filters, sub-tab states.
- **Responsive Design**:
  - Web/Tablet: Multi-column, side-by-side forms.
  - Mobile: Single-column, stacked forms.
- **Usability**:
  - Touch-friendly: Large buttons, padding (16px mobile, 24px tablet).
  - High-contrast: White background, black text (4.5:1 ratio).
  - Haptic feedback: Vibrations on button taps.
  - Offline support: Cache projects/BoM; sync actions when online.
- **Error Handling**:
  - Validate inputs (e.g., unique project name).
  - Display errors (e.g., “Failed to save BoM”).
  - Handle empty states (e.g., “No projects”).

## 7. Development Steps

1. Update main layout: Add “Projects” tab to Admin sidenav.
2. Wireframe: Design in Figma; validate with stakeholders.
3. Flutter: Create `AdminProjectsScreen` with `Scaffold`.
4. Firebase: Set up queries for `projects`, `bom`, `requests`, `audit_log`, `purchases`.
5. Build UI: Project list, detail view with sub-tabs, forms, charts.
6. Add Interactivity: Create/edit projects, manage BoM, link requests, add analytics.
7. Test: Responsiveness, real-time updates, offline support.
8. Deploy: Beta to TestFlight/Google Play Beta; monitor with Crashlytics.

## 8. Next Steps

- Finalize wireframe.
- Implement Firebase queries.
- Plan integration with other tabs (e.g., Approvals, Purchases).