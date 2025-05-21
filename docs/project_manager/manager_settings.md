# Abiezer Construction Project Manager Settings Tab Plan

## 1. Overview
The Settings tab allows Project Managers to manage their profile, notification preferences, and log out of the Abiezer Construction app. Built with Flutter, this tab is optimized for tablet and mobile use, ensuring a touch-friendly interface for onsite Project Managers.

## 2. Requirements
- Manage profile: Edit name and email.
- Set notification preferences: In-app, email, push (specific to assigned projects, e.g., low-stock alerts, request statuses).
- Provide logout functionality.
- Log profile changes in an audit trail for accountability.
- Ensure offline support for viewing settings, with sync on reconnect.

## 3. Workflow
1. Navigate to the Settings tab from the sidenav.
2. View profile details; edit name/email via a form.
3. Adjust notification toggles (in-app, email, push) and save preferences.
4. Logout via a button, redirecting to the login screen.
5. Navigate back to the Dashboard tab as needed.

## 4. UI Components
- **Profile Form**: `Form` with `TextFormField` for name and email.
- **Notification Toggles**: `Switch` for in-app, email, and push notifications.
- **Logout Button**: `ElevatedButton` for logout action.
- **Layout**: `ListView` for a single-column, scrollable layout optimized for mobile/tablet.

## 5. Features
Below are the features of the Settings Tab with detailed usage/UX examples.

- **Profile**:
  - **Description**: Allows Project Managers to view and edit their name and email.
  - **Usage/UX Example**: On May 21, 2025, at 11:56 AM SAST, Project Manager Sarah navigates to the Settings tab on her tablet while onsite. She sees her profile: “Sarah Kim, sarah@abiezer.com.” She taps “Edit,” updates her email to “sarah.kim@abiezer.com,” and submits. An audit log records: “Profile updated by Project Manager Sarah, 2025-05-21 11:57 AM.”
- **Notifications**:
  - **Description**: Provides toggles to enable/disable in-app, email, and push notifications for assigned projects (e.g., low-stock alerts, request status updates).
  - **Usage/UX Example**: Sarah sees toggles: “In-App Notifications: On,” “Email Notifications: Off,” “Push Notifications: On.” She toggles “Email Notifications” to “On” and submits. She now receives email alerts for low-stock notifications, such as “Cement low in Project Y” at 11:58 AM, related to her assigned projects.
- **Logout**:
  - **Description**: Ends the Project Manager’s session, redirecting to the login screen.
  - **Usage/UX Example**: After updating her settings, Sarah taps “Logout.” The app logs her out, and she’s redirected to the login screen, requiring re-authentication to access the app again.
- **Audit Trail**:
  - **Description**: Logs profile changes for accountability, accessible by Admins.
  - **Usage/UX Example**: An Admin later checks the audit trail and sees: “Profile updated by Project Manager Sarah, 2025-05-21 11:57 AM,” confirming Sarah’s recent email change.

## 6. Technical Details
- **Flutter Widgets**:
  - `Form` with `TextFormField` for profile editing.
  - `Switch` for notification toggles.
  - `ElevatedButton` for logout.
  - `ListView` for a single-column layout.
- **Firebase**:
  - `users` collection: Store profile data (name, email, notification preferences).
  - `audit_log` collection: Log profile changes (e.g., “Profile updated by Project Manager Sarah, 2025-05-21 11:57 AM”).
  - **Authentication**: Use Firebase Authentication to sign out.
- **State Management**: Use `Provider` to manage user profile state and notification preferences.
- **Responsive Design**: Stack form elements in a single-column `ListView`, optimized for tablet/mobile (16px padding, 48px min button size).
- **Offline Support**: Enable Firestore persistence for viewing settings offline; sync changes when online.
- **Error Handling**: Validate email format; display errors (e.g., “Invalid email address”).

## 7. Development Steps
1. Create a wireframe in Figma for the Settings tab, focusing on tablet/mobile usability.
2. Create a `PMSettingsScreen` widget with a `Scaffold` and `ListView`.
3. Set up Firestore queries to fetch and update profile data in the `users` collection.
4. Build the profile form, notification toggles, and logout button.
5. Implement audit logging to the `audit_log` collection for profile changes.
6. Test profile updates, notification preferences, logout, and offline support (e.g., simulate onsite conditions with no connectivity).
7. Deploy to beta for stakeholder review.

## 8. Next Steps
- Finalize wireframe and validate with stakeholders for onsite usability.
- Test offline functionality and sync behavior.
- Gather feedback from Project Managers on notification preferences.