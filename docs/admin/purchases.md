# Abiezer Construction Admin Purchases Tab Plan

## 1. Overview
The Purchases tab allows Admins to manage purchase logging, approvals, and returns, with photo storage and audit logging. Built with Flutter for cross-platform use.

## 2. Requirements
- Log purchases: Product, quantity, price, payment method, photo.
- Approve/deny purchase/return requests.
- Search/filter by category, product, supplier, date.
- Store payment proofs in cloud.
- Log actions in audit trail.

## 3. Workflow
1. Navigate to Purchases tab; select project if needed.
2. View table of purchases; search/filter.
3. Log purchase: Fill form, upload photo, submit.
4. Handle requests: View pending, approve/deny/adjust, notify requester.
5. Handle returns: Approve/deny, update inventory.
6. View audit trail in modal.
7. Navigate to other tabs.

## 4. UI Components
- Table: `DataTable` for purchases.
- Form: `Form` for logging purchases/returns.
- Photo: `ImagePicker` for uploads.
- Search/Filter: `TextField`, `DropdownButton`.
- Buttons: “Log Purchase,” “Approve,” “Deny.”
- Modal: Audit trail.

## 5. Features
Below are the features of the Purchases Tab with detailed usage/UX examples.

- **View Purchases**:
  - **Description**: Displays a list of all purchases with details like project, product, quantity, price, payment method, status, and an optional photo of the receipt.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Bob navigates to the Purchases tab on his tablet. He sees a table: “Project X, Cement, 50 bags, $500, Credit Card, Completed, [Photo].” He taps the photo link to view the receipt image uploaded by the requester, confirming the purchase details.
- **Log Purchase**:
  - **Description**: Admins can log a new purchase by filling out a form with product, quantity, price, payment method, and an optional photo upload.
  - **Usage/UX Example**: Bob selects Project X and taps “Log Purchase.” He fills the form: Product (“Plywood”), Quantity (30 sheets), Price ($600), Payment Method (“Bank Transfer”), and uploads a photo of the receipt using his tablet’s camera. After submitting, the purchase appears in the table as “Completed,” and an audit log records: “Purchase logged for Plywood in Project X by Admin Bob, 2025-05-19 02:55 PM.”
- **Approve/Deny**:
  - **Description**: Admins can approve or deny purchase/return requests submitted by Project Managers, with an option to add comments for the requester.
  - **Usage/UX Example**: Bob sees a pending purchase request: “Project Y, Steel Rebar, 20 bars, $400, Requested by Jane Smith.” He taps “Approve,” adds a comment (“Approved for immediate delivery”), and submits. Jane receives a notification: “Purchase request approved, 2025-05-19 02:56 PM,” and the request status updates to “Approved.”
- **Search/Filter**:
  - **Description**: Allows searching purchases by product name and filtering by category, supplier, date, or status.
  - **Usage/UX Example**: Bob searches for “Cement” in the search bar, and the table filters to show only Cement purchases. He then filters by “Completed” status to see finalized purchases or by date “2025-05-18” to review purchases from that day.
- **Audit Trail**:
  - **Description**: Logs all purchase-related actions in a modal for accountability.
  - **Usage/UX Example**: Bob opens the audit trail modal and sees entries: “Purchase logged for Plywood by Admin Bob, 2025-05-19 02:55 PM,” “Purchase request for Steel Rebar approved by Admin Bob, 2025-05-19 02:56 PM.” He filters by “Project X” to focus on that project’s purchase history.

## 6. Technical Details
- **Flutter Widgets**:
  - `DataTable`: Purchase list.
  - `Form`, `ImagePicker`: Inputs.
  - `AlertDialog`: Confirmations.
- **Firebase**:
  - `purchases`: Purchase data.
  - `requests`: Purchase/return requests.
  - `audit_log`: Action logs.
  - **Cloud Storage**: Photos.
- **State Management**: Provider for data/filters.
- **Responsive**: Stack forms; adjust table.
- **Error Handling**: Validate uploads/saves.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `AdminPurchasesScreen`.
3. Set up Firestore/Storage for purchases, requests.
4. Build table, forms, search/filter.
5. Add interactivity: Log, approve, deny.
6. Test responsiveness and photo uploads.
7. Deploy to beta; monitor.

## 8. Next Steps
- Finalize wireframe.
- Implement Firebase storage.
- Plan Approvals tab.