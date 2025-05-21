# Abiezer Construction Admin Approvals Tab Plan

## 1. Overview
The Approvals tab centralizes Admin review of material, transfer, return, and purchase requests, with updates and notifications. Built with Flutter.

## 2. Requirements
- List pending requests: Material, transfer, return, purchase.
- Approve/deny/adjust with comments.
- Update BoM/inventory; notify requesters.
- Search/filter by type, project, requester, date.
- Log actions in audit trail.

## 3. Workflow
1. Navigate to Approvals tab.
2. View requests in table/cards; filter/search.
3. Click request; view details/photo.
4. Approve/deny/adjust; add comment; submit.
5. Update BoM/inventory; notify requester.
6. View audit trail in modal.
7. Navigate to other tabs.

## 4. UI Components
- List: `DataTable` or `Card` for requests.
- Form: `Form` for adjust/comment.
- Image: Display photo.
- Search/Filter: `TextField`, `DropdownButton`.
- Buttons: “Approve,” “Deny,” “Adjust.”

## 5. Features
Below are the features of the Approvals Tab with detailed usage/UX examples.

- **View Requests**:
  - **Description**: Displays a list of pending requests (material, transfer, return, purchase) with details like type, requester, project, material, quantity, reason, and optional photo.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Admin Alice navigates to the Approvals tab on her web browser. She sees a table: “Material Request, John Doe, Project X, Cement, 50 bags, Urgent need, [Photo].” She taps the photo to view an image of the site showing low Cement stock, helping her decide on the request.
- **Approve/Deny/Adjust**:
  - **Description**: Admins can approve, deny, or adjust requests (e.g., modify quantities) with comments, updating BoM/inventory and notifying requesters.
  - **Usage/UX Example**: Alice selects the Cement request and taps “Adjust.” She reduces the quantity to 40 bags, adds a comment (“Adjusted due to supplier availability”), and submits. The BoM for Project X updates (Cement total increases by 40), and John Doe receives a notification: “Request adjusted to 40 bags, 2025-05-19 02:55 PM.”
- **Search/Filter**:
  - **Description**: Allows searching requests by requester or project and filtering by type or date.
  - **Usage/UX Example**: Alice searches for “John Doe” in the search bar, filtering the table to show only John’s requests. She then filters by “Material Request” type to focus on material-related requests, or by date “2025-05-18” to see requests from that day.
- **Audit Trail**:
  - **Description**: Logs all approval actions in a modal for accountability.
  - **Usage/UX Example**: Alice opens the audit trail modal and sees: “Material request for Cement adjusted to 40 bags by Admin Alice, 2025-05-19 02:55 PM.” She filters by “Project X” to review all approval actions for that project.

## 6. Technical Details
- **Flutter Widgets**:
  - `DataTable`/`Card`: Requests.
  - `Form`, `Image`: Inputs.
- **Firebase**:
  - `requests`: Request data.
  - `audit_log`: Approval logs.
  - **Cloud Storage**: Photos.
  - Listeners: Stream requests.
- **State Management**: Provider for data/filters.
- **Responsive**: Cards on mobile.
- **Error Handling**: Validate updates.

## 7. Development Steps
1. Wireframe in Figma.
2. Create `AdminApprovalsScreen`.
3. Set up Firestore for requests.
4. Build list, forms, photo display.
5. Add interactivity: Approve/deny/adjust.
6. Test notifications and updates.
7. Deploy to beta.

## 8. Next Steps
- Finalize wireframe.
- Implement request streaming.
- Plan Reports tab.