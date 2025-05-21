# Abiezer Construction Admin Reports Tab Plan

## 1. Overview
The Reports tab enables Admins to generate and export BoM, usage, cost, trend, and audit reports, with filtering and visualization. Built with Flutter.

## 2. Requirements
- Generate reports: BoM, usage, cost, trends.
- Export as PDF/Excel.
- View audit trail of all actions.
- Filter by project, date, material, user, action.

## 3. Workflow
1. Navigate to Reports tab.
2. Select report type (BoM, Usage, Cost, Trend, Audit).
3. Configure: Select project, apply filters.
4. Generate: View table/chart.
5. Export: Download PDF/Excel.
6. View audit trail with filters.
7. Navigate to other tabs.

## 4. UI Components
- Dropdowns: Report type, filters.
- Table: `DataTable` for report data.
- Chart: Visualize trends.
- Button: Export PDF/Excel.

## 5. Features
Below are the features of the Reports Tab with detailed usage/UX examples.

- **Reports**:
  - **Description**: Generates reports for BoM, usage, cost, and trends, displaying data in tables or charts based on the selected type.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Bob selects “Usage Report” on his web browser. He chooses Project X and sets a date range (2025-05-01 to 2025-05-19). The report generates a table: “Cement, 50 bags used, 2025-05-18,” “Plywood, 20 sheets used, 2025-05-17,” with a line chart showing usage trends over the period.
- **Export**:
  - **Description**: Allows exporting reports as PDF or Excel files for sharing or record-keeping.
  - **Usage/UX Example**: After generating the Usage Report, Bob taps “Export to PDF.” A file named “Project_X_Usage_Report_2025-05-19.pdf” downloads, containing the table and chart. He emails it to his team for review.
- **Audit Trail**:
  - **Description**: Displays a comprehensive audit trail of all actions, filterable by project, date, material, user, or action type.
  - **Usage/UX Example**: Bob selects “Audit Report” and filters by Project X and date “2025-05-18.” He sees a timeline: “Cement usage logged by John Doe, 2025-05-18,” “Material request approved by Admin Alice, 2025-05-18,” helping him track project activity.
- **Filter**:
  - **Description**: Allows filtering reports by project, date, material, user, or action type for focused analysis.
  - **Usage/UX Example**: Bob generates a Cost Report and filters by material “Cement” and date range “2025-05-01 to 2025-05-19.” The report updates to show only Cement-related costs, totaling $1,000 across purchases and BoM allocations.

## 6. Technical Details
- **Flutter Widgets**:
  - `DropdownButton`, `DataTable`, `Charts`.
  - `Button` for export.
- **Firebase**:
  - `projects`, `purchases`, `audit_log`: Report data.
  - **Cloud Functions**: Aggregate data.
- **Export**: `pdf`, `excel` packages.
- **State Management**: Provider for data/filters.
- **Responsive**: Adjust table/chart size.
- **Error Handling**: Handle large data; export errors.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `AdminReportsScreen`.
3. Set up Firestore queries for report data.
4. Build table, chart, filters.
5. Implement export functionality.
6. Test large data sets and exports.
7. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Implement chart library.
- Plan Users tab.