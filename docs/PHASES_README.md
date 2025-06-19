# Project Manager BoM & Project Overview — Phased Build Documentation

---

## **Phase 1: Data Models & Providers**

**Purpose:**  
Establish robust, scalable data models and providers for all project, BoM, and action-related data.

**Key Features:**
- Define and document all core models: `ProjectModel`, `BillOfMaterials`, `MaterialModel`, `MaterialMovement`, etc.
- Implement and document providers for:
  - Fetching assigned projects for the current user.
  - Fetching BoM for a selected project.
  - Fetching material usage logs, requests, and audit logs.
- Add image upload utility with compression and size limits.
- Add notification utility for low-stock and action confirmations.

**How to Test:**
- Run provider fetches and ensure correct data is loaded for the current user.
- Test image upload and notification utilities with sample data.

---

## **Phase 2: Project BoM Tab & Project Card Integration**

**Purpose:**  
Create a responsive, user-friendly BoM tab for project managers, with project cards and quick actions.

**Key Features:**
- Display assigned projects as cards using the `ProjectCard` widget.
- Add search/filter bar and filter chips for easy navigation.
- Add quick actions (View BoM, Log Usage, Request Materials) as visible buttons inside each card (only for assigned projects).
- Make the entire card tappable to navigate to the Project Overview screen.
- Ensure all UI is responsive and follows the app theme.

**How to Test:**
- Switch between "All Projects" and "Assigned to Me" tabs.
- Use the search/filter bar to find projects.
- Tap quick actions and project cards to verify navigation and permissions.

---

## **Phase 3: Project Overview Screen**

**Purpose:**  
Provide a comprehensive, visually appealing hub for project managers to view and manage project details, team, timeline, documents, and BoM.

**Key Features:**
- Responsive layout:
  - On mobile: Metric cards (compact) above project details.
  - On tablet/desktop: Row with project details (left) and metric cards (right).
- Project details: name, status, location, description, dates, managers.
- Tabs for:
  - **Team:** All team members with profile pictures.
  - **Timeline:** Add, edit, and view project timelines.
  - **Documents:** Upload, view, and delete project documents.
- Large, prominent "View Bill of Materials" button below tabs.
- No image or "Log Leftovers" button here (handled in a later phase).

**How to Test:**
- Navigate to the Project Overview screen from a project card.
- Verify responsive layout and correct display of project details and metrics.
- Switch between tabs and test their content and actions.
- Use the "View Bill of Materials" button to navigate to the BoM page.

---

## **Future Phases (Planned)**

### **Phase 4: Bill of Materials Page & Action Flows**
- Build the BoM page for each project.
- Implement all material actions: Log Usage, Request, Transfer/Return, Log Leftovers.
- Add real-time updates and offline support.

### **Phase 5: Mark Project Complete Process**
- Implement a "Mark Project Complete" workflow.
- Integrate leftovers logging and final project audit.

### **Phase 6: Advanced Features & Polish**
- Add notifications, daily digests, and advanced analytics.
- Conduct usability testing and refine UI/UX.
- Write comprehensive widget and integration tests.

---

**How to Use This README:**
- Reference each section as you build out the corresponding phase.
- Update with implementation details, screenshots, and usage notes as you progress.
- Use as onboarding documentation for new team members or contributors. 