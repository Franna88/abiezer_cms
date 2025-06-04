# Abiezer Construction Admin Users Tab Plan

## 1. Overview
The Users tab allows Admins to manage user roles, project assignments, and permissions, with audit logging. Built with Flutter.

## 2. Requirements
- Manage users: Add, edit, deactivate.
- Assign Project Managers to projects.
- Set permissions for BoM/other actions.
- Log changes in audit trail.

## 3. Workflow
1. Navigate to Users tab.
2. View user table; search/filter.
3. Add/edit user via form (name, email, role, projects, permissions).
4. Users are displayed via a user card container.
5. Deactivate user with confirmation.
6. View audit trail in modal.
7. Navigate to other tabs.

## 4. UI Components
- Table: `DataTable` for users.
- Form: `Form` for add/edit.
- MultiSelect: Projects, permissions.
- Search: `TextField`.

## 5. Features
Below are the features of the Users Tab with detailed usage/UX examples.

- **View Users**:
  - **Description**: Displays a list of users with their name, role, assigned projects, and permissions.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Alice navigates to the Users tab on her tablet. She sees a table: “John Doe, Project Manager, Project X, BoM Access: Yes,” “Jane Smith, Project Manager, Project Y, BoM Access: Yes.” She taps on John Doe to view his full profile details.
- **Manage Users**:
  - **Description**: Allows Admins to add new users, edit existing user details (name, email, role), or deactivate users with confirmation.
  - **Usage/UX Example**: Alice taps “Add User” and fills out a form: Name (“Mark Brown”), Email (“mark@abiezer.com”), Role (“Project Manager”). She submits, and Mark appears in the table. Later, she edits Jane Smith’s email to “jane.smith@abiezer.com” and deactivates an old user, confirming the action in a dialog. An audit log records: “Added user Mark Brown by Admin Alice, 2025-05-19 02:55 PM.”
- **Assign Projects**:
  - **Description**: Assigns Project Managers to specific projects using a multi-select dropdown.
  - **Usage/UX Example**: Alice edits John Doe’s profile, selecting Project Z in the multi-select dropdown to assign him to that project in addition to Project X. She submits, and John receives a notification: “Assigned to Project Z, 2025-05-19 02:56 PM.”
- **Set Permissions**:
  - **Description**: Defines user permissions (e.g., BoM access, request submission) for granular control.
  - **Usage/UX Example**: Alice edits Mark Brown’s profile, toggling “BoM Access” to “Yes” and “Request Submission” to “Yes.” She submits, and Mark can now access BoM features for his assigned projects.
- **Audit Trail**:
  - **Description**: Logs all user management actions in a modal.
  - **Usage/UX Example**: Alice opens the audit trail modal and sees: “Added user Mark Brown by Admin Alice, 2025-05-19 02:55 PM,” “Assigned John Doe to Project Z by Admin Alice, 2025-05-19 02:56 PM.” She filters by “Mark Brown” to review his onboarding actions.

## 6. Technical Details
- **Flutter Widgets**:
  - `DataTable`, `Form`, `MultiSelect`.
  - `TextField` for search.
- **Firebase**:
  - `users`: User data.
  - `audit_log`: Action logs.
  - **Authentication**: Firebase Auth.
- **State Management**: Provider for data/filters.
- **Responsive**: Stack forms.
- **Error Handling**: Validate inputs.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `AdminUsersScreen`.
3. Set up Firestore/Auth for users.
4. Build table, forms, search.
5. Add interactivity: Add/edit/deactivate.
6. Test user assignments.
7. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Implement Auth integration.
- Plan Settings tab.