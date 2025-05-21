# Abiezer Construction Admin BoM Tab Plan

## 1. Overview
The Bill of Materials (BoM) tab enables Admins to manage the master material catalog and project-specific BoMs, with real-time updates and audit logging. Built with Flutter for web, iOS, Android, and tablet, it’s accessible only to Admins.

## 2. Requirements
- Manage master catalog: Add, edit, deactivate, categorize materials.
- Manage project BoMs: View, adjust, correct, set thresholds.
- Search/filter materials by name/category.
- Show low-stock alerts; allow material requests.
- Log all actions in audit trail.

## 3. Workflow
1. Navigate to BoM tab via sidenav.
2. Toggle Master Catalog or Project BoM (default: Project BoM if project selected).
3. **Master Catalog**:
   - View table: Name, category, unit, cost, supplier, active.
   - Add/edit via form; deactivate with confirmation.
   - Search/filter materials.
4. **Project BoM**:
   - View table: Name, category, unit, total, used, remaining, low-stock.
   - Adjust quantities, correct entries, set thresholds via forms.
   - Request material for low stock (links to Purchases).
   - Search/filter materials.
5. View audit trail in modal.
6. Navigate to other tabs or switch project.

## 4. UI Components
- Header: “BoM” title, toggle for Catalog/Project views.
- Table: `DataTable` for materials (sortable).
- Search: `TextField` for name.
- Filter: `DropdownButton` for category.
- Forms: `Form` for add/edit, adjust, thresholds.
- Buttons: “Add Material,” “Adjust,” “Correct,” “Set Threshold,” “Request More.”
- Modal: Audit trail view.

## 5. Features
Below are the features of the BoM Tab with detailed usage/UX examples.

- **Master Catalog**:
  - **Description**: Allows Admins to add new materials, edit existing ones, deactivate materials (preserving historical data), and categorize materials for organization.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Alice switches to the Master Catalog view on her web browser. She taps “Add Material,” filling out a form: Name (“Steel Rebar”), Category (“Steel”), Unit (“bars”), Cost ($5), Supplier (“XYZ Corp”). After submitting, Steel Rebar appears in the table. She later edits “Cement” to update its cost to $11 and deactivates “Old Plywood” after a confirmation dialog, ensuring it’s unavailable for new projects but remains in historical BoMs. An audit log records: “Added Steel Rebar by Admin Alice, 2025-05-19 02:54 PM.”
- **Project BoM**:
  - **Description**: Displays project-specific BoM with details like total, used, and remaining quantities; allows Admins to adjust allocations, correct errors, and set low-stock thresholds.
  - **Usage/UX Example**: Alice selects Project X in the top bar and switches to the Project BoM view. The table shows Cement (100 total, 60 used, 40 remaining, threshold 20, low-stock). She taps “Adjust” on Cement, increasing the total to 120 bags, and the table updates (120 total, 60 used, 60 remaining). She then corrects an error by setting “used” to 55 bags (65 remaining) and sets a new threshold of 30 bags, clearing the low-stock alert. An audit log records: “Adjusted Cement to 120 bags in Project X by Admin Alice, 2025-05-19 02:55 PM.”
- **Search/Filter**:
  - **Description**: Enables searching materials by name and filtering by category in both Master Catalog and Project BoM views.
  - **Usage/UX Example**: In the Master Catalog view, Alice types “Cement” in the search bar, and the table filters to show only Cement. She then selects the “Steel” category from the dropdown, and the table updates to show Steel Rebar and other steel materials. In Project X’s BoM, she filters by “Cement” category to focus on Cement-related entries.
- **Notifications**:
  - **Description**: Displays low-stock alerts for project materials with a “Request More” button linking to the Purchases tab.
  - **Usage/UX Example**: A low-stock alert appears in Project X’s BoM: “Cement below threshold: 40 remaining, threshold 20.” Alice taps “Request More,” navigating to the Purchases tab with a pre-filled form for 50 more bags of Cement, which she submits for approval.
- **Audit Trail**:
  - **Description**: Logs all actions (e.g., material added, quantity adjusted) in a modal for accountability.
  - **Usage/UX Example**: Alice opens the audit trail modal from the BoM tab. She sees entries: “Added Steel Rebar to Master Catalog by Admin Alice, 2025-05-19 02:54 PM,” “Adjusted Cement in Project X by Admin Alice, 2025-05-19 02:55 PM.” She filters by “Project X” to review all changes related to that project.

## 6. Technical Details
- **Flutter Widgets**:
  - `Scaffold`: Tab layout.
  - `TabBar`: Catalog/Project toggle.
  - `DataTable`: Material lists.
  - `Form`, `TextField`, `DropdownButton`: Inputs.
  - `AlertDialog`: Confirmations.
- **Firebase**:
  - `materials`: Catalog data.
  - `projects/{projectId}/bom`: Project BoM data.
  - `audit_log`: Change logs.
  - Listeners: Stream BoM and audit log.
- **State Management**: Provider for data and filters.
- **Responsive**: Adjust table columns; stack forms on mobile.
- **Error Handling**: Validate inputs; show update errors.

## 7. Development Steps
1. Wireframe in Figma; validate with stakeholders.
2. Create `AdminBoMScreen` with `Scaffold`, `TabBar`.
3. Set up Firestore queries for catalog, BoM, audit log.
4. Build table, search, filter, and forms.
5. Add interactivity: Add/edit, adjust, request.
6. Test responsiveness and real-time updates.
7. Deploy to beta; monitor with Crashlytics.

## 8. Next Steps
- Finalize wireframe.
- Implement Firebase queries.
- Plan next tab (Purchases).