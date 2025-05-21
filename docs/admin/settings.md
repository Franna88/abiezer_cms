# Abiezer Construction Admin Settings Tab Plan

## 1. Overview
The Settings tab allows Admins to manage their profile, notification preferences, and log out. Built with Flutter.

## 2. Requirements
- Manage profile: Edit name, email.
- Set notification preferences: In-app, email, push.
- Provide logout.
- Log profile changes.

## 3. Workflow
1. Navigate to Settings tab.
2. View profile; edit name/email via form.
3. Set notification toggles; save.
4. Logout via button.
5. Navigate to Dashboard.

## 4. UI Components
- Form: `Form` for profile.
- Toggles: `Switch` for notifications.
- Button: Logout.

## 5. Features
Below are the features of the Settings Tab with detailed usage/UX examples.

- **Profile**:
  - **Description**: Allows Admins to view and edit their name and email.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Bob navigates to the Settings tab on his tablet. He sees his profile: “Bob Johnson, bob@abiezer.com.” He taps “Edit,” updates his email to “bob.johnson@abiezer.com,” and submits. An audit log records: “Profile updated by Admin Bob, 2025-05-19 02:55 PM.”
- **Notifications**:
  - **Description**: Provides toggles to enable/disable in-app, email, and push notifications.
  - **Usage/UX Example**: Bob sees toggles: “In-App Notifications: On,” “Email Notifications: Off,” “Push Notifications: On.” He toggles “Email Notifications” to “On” and submits. He now receives email alerts for low-stock notifications, such as “Cement low in Project X” at 02:56 PM.
- **Logout**:
  - **Description**: Ends the Admin’s session, redirecting to the login screen.
  - **Usage/UX Example**: After updating his settings, Bob taps “Logout.” The app logs him out, and he’s redirected to the login screen, requiring re-authentication to access the app again.
- **Audit Trail**:
  - **Description**: Logs profile changes for accountability.
  - **Usage/UX Example**: Bob checks the audit trail (accessible via another tab) and sees: “Profile updated by Admin Bob, 2025-05-19 02:55 PM,” confirming his recent email change.

## 6. Technical Details
- **Flutter Widgets**:
  - `Form`, `Switch`, `Button`.
- **Firebase**:
  - `users`: Profile data.
  - `audit_log`: Change logs.
  - **Authentication**: Sign out.
- **State Management**: Provider for profile.
- **Responsive**: Stack form.
- **Error Handling**: Validate email.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `AdminSettingsScreen`.
3. Set up Firestore for profile.
4. Build form, toggles, logout.
5. Test profile updates and logout.
6. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Complete Admin tab planning.