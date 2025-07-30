# BottleCRM Mobile Refactoring Plan

## Overview
This document tracks the incremental refactoring/modernization of BottleCRM Mobile screens and components.

## Refactoring Strategy

### Folder Structure
```
lib/ui/screens/
├── [original files]     # Legacy screens in original locations
└── modern/              # Refactored screens
    ├── authentication/ # Modern auth screens
    ├── dashboard_screen.dart
    └── shared/          # Common components
```

### Progress Tracking

## 📱 Screens Status

### ✅ Authentication Module
- [x] `login.dart` → `modern/authentication/login_screen.dart` - ✨ **MODERNIZED** (JWT token handling, improved UI)
- [x] `companies_List.dart` → `modern/authentication/organization_selection_screen.dart` - ✨ **ENHANCED** (Search functionality, gradient designs, staggered animations, improved responsive layouts)
- [ ] `register.dart` - 🔄 **PENDING**
- [ ] `forgot_password.dart` - 🔄 **PENDING**
- [ ] `change_password.dart` - 🔄 **PENDING**
- [ ] `profile.dart` - 🔄 **PENDING**

### ✅ Dashboard Module
- [x] `dashboard.dart` → `modern/dashboard_screen.dart` - ✨ **MODERNIZED** (Responsive design, modern state management, enhanced UX)

### 🔄 CRM Modules
#### Accounts
- [ ] `accounts_list.dart` - 🔄 **PENDING**
- [ ] `account_create.dart` - 🔄 **PENDING**
- [ ] `account_details.dart` - 🔄 **PENDING**

#### Contacts
- [ ] `contacts_list.dart` - 🔄 **PENDING**
- [ ] `contact_create.dart` - 🔄 **PENDING**
- [ ] `contact_details.dart` - 🔄 **PENDING**

#### Leads
- [ ] `leads_list.dart` - 🔄 **PENDING**
- [ ] `lead_create.dart` - 🔄 **PENDING**
- [ ] `lead_details.dart` - 🔄 **PENDING**

#### Opportunities
- [ ] `opportunities_list.dart` - 🔄 **PENDING**
- [ ] `opportunitie_create.dart` - 🔄 **PENDING**
- [ ] `opportunitie_details.dart` - 🔄 **PENDING**

#### Cases
- [ ] `cases_list.dart` - 🔄 **PENDING**
- [ ] `case_create.dart` - 🔄 **PENDING**
- [ ] `case_details.dart` - 🔄 **PENDING**

#### Tasks
- [ ] `tasks_list.dart` - 🔄 **PENDING**
- [ ] `task_create.dart` - 🔄 **PENDING**
- [ ] `task_details.dart` - 🔄 **PENDING**

#### Events
- [ ] `events_list.dart` - 🔄 **PENDING**
- [ ] `event_create.dart` - 🔄 **PENDING**
- [ ] `event_details.dart` - 🔄 **PENDING**

#### Documents
- [ ] `documents_list.dart` - 🔄 **PENDING**
- [ ] `document_create.dart` - 🔄 **PENDING**
- [ ] `document_details.dart` - 🔄 **PENDING**

#### Teams
- [ ] `teams_list.dart` - 🔄 **PENDING**
- [ ] `team_create.dart` - 🔄 **PENDING**
- [ ] `team_details.dart` - 🔄 **PENDING**

#### Users
- [ ] `users_list.dart` - 🔄 **PENDING**
- [ ] `user_create.dart` - 🔄 **PENDING**
- [ ] `user_details.dart` - 🔄 **PENDING**

#### Invoices
- [ ] `invoices_list.dart` - 🔄 **PENDING**
- [ ] `invoice_create.dart` - 🔄 **PENDING**
- [ ] `invoice_details.dart` - 🔄 **PENDING**

#### Settings
- [ ] `settings.dart` - 🔄 **PENDING**
- [ ] `settings_details.dart` - 🔄 **PENDING**
- [ ] `settings_userDetails.dart` - 🔄 **PENDING**

## 🎯 Modernization Goals

### Technical Improvements
- [ ] **State Management**: Migrate from custom BLoC to modern state management (Riverpod/Bloc)
- [ ] **UI Framework**: Adopt modern Flutter widgets and Material 3
- [ ] **Architecture**: Implement clean architecture patterns
- [ ] **Error Handling**: Standardize error handling across screens
- [ ] **Loading States**: Consistent loading and empty states
- [ ] **Responsive Design**: Enhanced responsive layouts
- [ ] **Accessibility**: Add accessibility features
- [ ] **Testing**: Add unit and widget tests

### UI/UX Improvements
- [ ] **Design System**: Create consistent design tokens
- [ ] **Dark Mode**: Implement system-wide dark mode
- [ ] **Animations**: Add smooth transitions and micro-animations
- [ ] **Performance**: Optimize rendering and memory usage
- [ ] **Offline Support**: Add offline capabilities where applicable

## 🔄 Routing Updates

### Modern Routes (Active)
- `/login` → `LoginScreen()` (modern login)
- `/organization_selection` → `OrganizationSelectionScreen()` (modern org selection)
- `/dashboard` → `ModernDashboardScreen()` (modern dashboard)

### Legacy Routes (Backup)
- `/login_legacy` → `Login()` (original login)
- `/companies_List` → `CompaniesList()` (original companies list)
- `/dashboard_legacy` → `Dashboard()` (original dashboard)

## 📋 Migration Steps

### Phase 1: Authentication & Core (✨ COMPLETED)
1. ✅ Login screen with JWT handling → **MOVED** to `modern/authentication/`
2. ✅ Organization selection with role display → **MOVED** to `modern/authentication/`
3. ✅ Profile model updates

### Phase 2: Dashboard & Navigation (✅ COMPLETED)
1. ✅ Modern dashboard with cards and analytics → **MOVED** to `modern/dashboard_screen.dart`
2. 🔄 Bottom navigation improvements
3. 🔄 Side drawer/app bar enhancements

### Phase 3: CRM Modules (📅 PLANNED)
1. 📅 Accounts module modernization
2. 📅 Contacts module modernization
3. 📅 Leads module modernization
4. 📅 Continue with remaining modules...

## 🔧 Development Guidelines

### File Naming Convention
- Legacy files: Keep original names in `legacy/` folder
- Modern files: Use descriptive names with `_screen.dart` suffix
- Shared components: Use `component_name.dart` in `shared/`

### Code Standards
- Use null safety throughout
- Implement proper error handling
- Add documentation comments
- Follow Flutter best practices
- Use consistent coding style

### Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows

## 📊 Progress Metrics

**Overall Progress**: 9.4% (3/32 screens completed)

### By Module:
- Authentication: 33% (2/6)
- Dashboard: 100% (1/1) ✅
- CRM Modules: 0% (0/25)

---

*Last Updated: 2025-01-30*
*Next Review: After completing Phase 2*