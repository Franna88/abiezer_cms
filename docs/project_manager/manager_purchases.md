# Abiezer Construction Project Manager Purchases Tab Plan

## 1. Overview
The Purchases tab enables Project Managers to submit purchase requests and view statuses, optimized for tablet/mobile with camera integration. Built with Flutter for onsite use.

## 2. Requirements
- Log requests: Product, quantity, price, payment method, photo.
- View statuses: Pending, Approved, Denied.
- Search/filter by product, date, status.
- Notify for approvals/denials.
- Touch-friendly, offline support.

## 3. Workflow
1. Navigate to Purchases tab; select project.
2. Scroll cards/table; search/filter.
3. Tap “New Request”; fill form, upload photo; submit.
4. View status updates; tap for details.
5. Navigate to other tabs.

## 4. UI Components
- Requests: `ListView` (mobile) or `DataTable` (tablet).
- Form: `Form` for requests.
- Photo: `ImagePicker` for camera.
- Search/Filter: `TextField`, `DropdownButtonFormField`.
- Button: `ElevatedButton` (48px).

## 5. Features
Below are the features of the Project Manager Purchases Tab with detailed usage/UX examples.

- **Log Request**:
  - **Description**: Allows Project Managers to submit purchase requests with product, quantity, price, payment method, and an optional photo.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Project Manager Jane Smith selects Project Y on her tablet. She taps “New Request,” filling out: Product (“Steel Rebar”), Quantity (20 bars), Price ($400), Payment Method (“Credit Card”), and uploads a photo of the supplier’s quote. She submits, and the request appears as “Pending” in the list, awaiting Admin approval.
- **View Requests**:
  - **Description**: Displays a list of purchase requests with their statuses (Pending, Approved, Denied) and details.
  - **Usage/UX Example**: Jane sees a list: “Steel Rebar, 20 bars, $400, Pending, 2025-05-19,” “Cement, 50 bags, Approved, 2025-05-18.” She taps the Cement request to view details, seeing a comment from Admin Alice: “Approved for immediate delivery.”
- **Search/Filter**:
  - **Description**: Allows searching requests by product and filtering by date or status.
  - **Usage/UX Example**: Jane searches for “Cement” in the search bar, and the list filters to show only Cement requests. She then filters by “Approved” status to see all approved purchases, focusing on finalized orders.
- **Notifications**:
  - **Description**: Sends alerts for approval or denial of requests.
  - **Usage/UX Example**: Jane receives a notification: “Purchase request for Steel Rebar approved, 2025-05-19 02:55 PM.” She taps it, navigating to the Purchases tab to view the updated status and Admin comment.

## 6. Technical Details
- **Flutter Widgets**:
  - `ListView`, `DataTable`, `Form`, `ImagePicker`.
  - `TextField`, `DropdownButtonFormField`.
- **Firebase**:
  - `requests`: Purchase requests.
  - `notifications`: Alerts.
  - Cloud Storage: Photos.
  - Listeners: Stream requests.
- **State Management**: Provider for data/filters.
- **Responsive**: Cards mobile; table tablet.
- **Usability**: Camera, haptic feedback, offline.
- **Error Handling**: Validate inputs, uploads.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `PMPurchasesScreen`.
3. Set up Firestore/Storage.
4. Build cards/table, form, search/filter.
5. Add camera, offline support.
6. Test photo uploads, statuses.
7. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Test camera integration.
- Plan My Productivity tab.