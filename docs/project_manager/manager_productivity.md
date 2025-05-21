# Abiezer Construction Project Manager My Productivity Tab Plan

## 1. Overview
The My Productivity tab provides read-only reports on assigned projects and material usage, optimized for tablet/mobile with export options. Built with Flutter.

## 2. Requirements
- List projects: Current, past.
- Show usage logs: Material, quantity, date, note, photo.
- Search/filter by project, date, material.
- Export PDF/Excel.
- Touch-friendly, high-contrast.

## 3. Workflow
1. Navigate to My Productivity tab.
2. Scroll project cards; search/filter.
3. Tap project; scroll log cards; search/filter.
4. Export: Select project/date; tap “Export.”
5. Navigate to other tabs.

## 4. UI Components
- Projects/Logs: `ListView` (mobile) or `DataTable` (tablet).
- Search/Filter: `TextField`, `DropdownButtonFormField`.
- Button: `ElevatedButton` for export (48px).

## 5. Features
Below are the features of the My Productivity Tab with detailed usage/UX examples.

- **Projects**:
  - **Description**: Displays a list of assigned projects (current and past) with name, location, and status.
  - **Usage/UX Example**: On May 19, 2025, at 02:54 PM SAST, Project Manager John Doe navigates to the My Productivity tab on his tablet. He sees cards: “Project X