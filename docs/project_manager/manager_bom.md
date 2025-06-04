# Abiezer Construction Project Manager BoM Tab Plan

## 1. Overview
The BoM tab enables Project Managers to view project BoMs, log usage, request materials, initiate transfers/returns, and log leftovers, optimized for tablet/mobile with Flutter. It’s touch-friendly, camera-integrated, and supports offline use.

## 2. Requirements
- View BoM: Material, category, unit, total, used, remaining, low-stock.
- Log usage: Quantity, note, photo.
- Request materials: Quantity, reason, photo.
- Transfer/return materials: Quantity, reason, photo.
- Log leftovers: Mark remaining quantities.
- Search/filter by material/category.
- Low-stock alerts, offline support.

## 3. Workflow
1. Navigate to BoM tab; view list of all projects live and view list of projects assigned to them. Project managers can only access and manage projects they are assigned to.
2. Scroll cards/table; search/filter.
3. Log usage: Tap material, enter quantity, note, photo; submit.
4. Request material: Tap “Request More”; fill form; submit.
5. Transfer/return: Fill form; submit.
6. Log leftovers: Select materials, quantities; submit.
7. Navigate to other tabs.

## 4. UI Components
- BoM: `ListView` (mobile) or `DataTable` (tablet).
- Forms: `Form` for actions.
- Photo: `ImagePicker` for camera.
- Search/Filter: `TextField`, `DropdownButtonFormField`.
- Buttons: `ElevatedButton` (48px).

## 5. Features
Below are the features of the Project Manager BoM Tab with detailed usage/UX examples.

- **View BoM**:
  - **Description**: Displays the BoM for the selected project with material details (name, category, unit, total, used, remaining, low-stock status) in cards (mobile) or a table (tablet).
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Project Manager John Doe selects Project X on his tablet. He sees cards: “Cement, Cement Category, bags, 100 total, 60 used, 40 remaining, Low-Stock,” “Plywood, Boards & Sheets, sheets, 50 total, 20 used, 30 remaining.” He taps Cement to log usage.
- **Log Usage**:
  - **Description**: Allows Project Managers to log material usage by specifying quantity, adding a note, and uploading a photo.
  - **Usage/UX Example**: John taps “Log Usage” on Cement in Project X. He enters Quantity (10 bags), Note (“Used for foundation”), and takes a photo of the site with his tablet’s camera. After submitting, the BoM updates: “Cement, 100 total, 70 used, 30 remaining,” and an audit log records: “Usage logged for Cement by John Doe, 2025-05-19 02:55 PM.”
- **Request Material**:
  - **Description**: Enables requesting additional materials for low-stock items with a form for quantity, reason, and photo.
  - **Usage/UX Example**: Cement in Project X shows “Low-Stock.” John taps “Request More,” filling out: Quantity (50 bags), Reason (“Urgent need for foundation”), and uploads a photo of the depleted stock. He submits, and the request appears in the Admin’s Approvals tab with status “Pending.”
- **Transfer/Return**:
  - **Description**: Allows initiating material transfers to another project or returns to inventory, with quantity, reason, and photo.
  - **Usage/UX Example**: John has excess Plywood in Project X. He taps “Transfer,” selecting Project Z as the destination, Quantity (10 sheets), Reason (“Excess stock”), and uploads a photo of the Plywood. He submits, and the request goes to the Admin for approval, with an audit log: “Transfer request for Plywood initiated by John Doe, 2025-05-19 02:56 PM.”
- **Log Leftovers**:
  - **Description**: Marks remaining materials as leftovers at project completion, updating inventory.
  - **Usage/UX Example**: Project X is nearing completion. John taps “Log Leftovers,” selecting Cement (30 bags remaining) and Plywood (20 sheets remaining). He submits, and the leftovers are recorded for inventory, with an audit log: “Leftovers logged for Project X by John Doe, 2025-05-19 02:57 PM.”
- **Search/Filter**:
  - **Description**: Allows searching materials by name and filtering by category.
  - **Usage/UX Example**: John searches for “Cement” in Project X’s BoM, and the list filters to show only Cement. He then filters by “Boards & Sheets” category to focus on Plywood and similar materials.
- **Notifications**:
  - **Description**: Shows low-stock alerts with a “Request More” button.
  - **Usage/UX Example**: A notification appears: “Low Stock: Cement in Project X, 30 remaining, below threshold 20.” John taps it, navigating to the “Request More” form, where he requests 50 more bags.

## 6. Technical Details
- **Flutter Widgets**:
  - `ListView`, `DataTable`, `Form`, `ImagePicker`.
  - `TextField`, `DropdownButtonFormField`.
- **Firebase**:
  - `projects/{projectId}/bom`: BoM data.
  - `requests`: Requests.
  - `notifications`: Alerts.
  - Cloud Storage: Photos.
  - Listeners: Stream data.
- **State Management**: Provider for data/filters.
- **Responsive**: Cards mobile; table tablet.
- **Usability**: Camera upload, haptic feedback, offline.
- **Error Handling**: Validate inputs, uploads.

## 7. Development Steps
1. Wireframe in Figma for tablet/mobile.
2. Create `PMBoMScreen`.
3. Set up Firestore/Storage.
4. Build cards/table, forms, search/filter.
5. Add camera, offline support.
6. Test onsite usability.
7. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Test camera integration.
- Plan Purchases tab.