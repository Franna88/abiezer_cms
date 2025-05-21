# Abiezer Construction App Front-End Plan (Admin and Project Manager Views)

**Note**: This is a partial version of the front-end plan (artifact_id: 9c28cabe-eaef-42fb-a371-133f6fa9d79a), currently including only the Main Layout artifact. Additional artifacts (e.g., Admin Dashboard, Project Manager BoM) will be added as they are retrieved.

## 1. Introduction
This document outlines the front-end structure for the Abiezer Construction app, a cross-platform (web, mobile, tablet) application built with Flutter to streamline material management, purchasing, user roles, project tracking, and reporting. It covers the **Admin view** (full access for comprehensive management) and the **Project Manager view** (onsite, tablet/mobile-optimized for assigned projects). The Project Manager view prioritizes touch-friendly interfaces, camera integration, and offline support for construction site use. The plan aligns with the provided scope and Admin BoM details, ensuring responsive, intuitive workflows. Please review the layout, features, and flows for both views and provide feedback to guide next steps.

## 2. Main Layout and Structure
The app uses a consistent layout with a sidebar navigation (sidenav), top bar, and main content area, tailored for Admin and Project Manager roles:
- **Sidenav**: Persistent on web, collapsible on tablet/mobile; shows role-specific tabs.
- **Top Bar**: Project selector (all projects for Admins, assigned projects for Project Managers), user info, notifications, and hamburger menu (tablet/mobile).
- **Main Content**: Tab-specific content, single-column on mobile, optional two-column on tablet/web.
- **Footer (Optional)**: Version/support contact, hidden on tablet/mobile.

**Admin Tabs**: Dashboard, Projects, Bill of Materials (BoM), Purchases, Approvals, Reports, Users, Settings.  
**Project Manager Tabs**: Dashboard, BoM, Purchases, My Productivity, Settings (tablet/mobile-optimized).

The following artifact details the main layout, finalized after clarifying Project Manager roles (onsite, limited to logging usage, requests, returns, leftovers, and productivity reports).
