# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BottleCRM Mobile is a Flutter-based CRM application for startups and enterprises. The app follows a modular architecture with consistent patterns across CRM entities (Accounts, Contacts, Leads, Opportunities, Cases, Tasks, Events, Documents, Teams, Users, Invoices).

## Build & Development Commands

```bash
# Clean and prepare
flutter clean
flutter pub get

# Build for release
flutter build appbundle  # Android App Bundle for Play Store
flutter build apk        # Android APK

# Development
flutter run              # Run in debug mode
flutter test             # Run tests
```

## Architecture Overview

### State Management
- **Pattern**: Custom BLoC-like pattern with singleton instances
- **Location**: `lib/bloc/` directory
- **Key Blocs**: `authBloc`, `dashboardBloc`, and module-specific blocs
- **Access**: Global singleton instances (e.g., `AuthBloc().getInstance()`)

### API Layer
- **Base Service**: `CrmService` in `lib/services/crm_services.dart`
- **Configuration**: Environment-based API URLs via `lib/config/api_config.dart`
  - **Development**: `http://localhost:3001/` (debug builds)
  - **Production**: `https://api.bottlecrm.io/` (release builds)
- **Authentication**: JWT token-based with SharedPreferences storage
- **Google OAuth**: Integrated with `google_sign_in` package
- **Multi-tenancy**: Organization header support

### Navigation
- **Pattern**: Named routes defined in `main.dart`
- **Home Screen**: Login screen (no splash screen)
- **Bottom Navigation**: 5 tabs for main app sections

### Module Structure
Each CRM module follows a consistent pattern:
```
lib/ui/screens/{module}/
├── {module}_list.dart    # List/index view
├── {module}_create.dart  # Create new entity
└── {module}_details.dart # View/edit entity
```

Available modules: accounts, contacts, leads, opportunities, cases, tasks, events, documents, teams, users, invoices

### Responsive Design
- **Helper**: `lib/responsive.dart`
- **Breakpoints**: Mobile (<650px), Tablet (650-1100px), Desktop (>1100px)
- **Usage**: `Responsive.isMobile(context)`, `Responsive.isTablet(context)`, `Responsive.isDesktop(context)`

## Key Files & Directories

- **Entry Point**: `lib/main.dart` - Contains all route definitions and app configuration
- **Models**: `lib/model/` - Dart classes for CRM entities
- **Services**: `lib/services/` - API communication and network layer
- **Configuration**: `lib/config/` - API URLs and environment configuration
- **Widgets**: `lib/ui/widgets/` - Reusable UI components
- **Utils**: `lib/utils/` - Validation helpers and utilities
- **Assets**: `assets/images/` - SVG icons and images for each module

## Development Patterns

### Adding New Routes
Add routes to the `routes` map in `main.dart`:
```dart
'/new-screen': (context) => NewScreen(),
```

### Creating New Modules
1. Create model in `lib/model/`
2. Create bloc in `lib/bloc/`
3. Create screens following the pattern: `{module}_list.dart`, `{module}_create.dart`, `{module}_details.dart`
4. Add API methods to `CrmService`
5. Add routes in `main.dart`

### API Integration
Extend `CrmService` class with new methods. Use the established pattern:
```dart
Future<List<Entity>> getEntities() async {
  // Implementation follows existing pattern
}
```

### UI Styling
- **Primary Color**: `#3E79F7` (blue)
- **Background**: `#ECEEF4` (light gray)
- **Custom Widgets**: Use existing widgets like `DashboardCountCard`, `RecentCardWidget`

## Refactoring Plan

**IMPORTANT**: This project is undergoing incremental refactoring/modernization. Before enhancing any screen:

1. **Check REFACTORING_PLAN.md** for the current status of the screen
2. **If modernizing a screen**:
   - Create new version in `lib/ui/screens/modern/` directory
   - Follow the modern patterns established in completed screens
   - Update the progress status in REFACTORING_PLAN.md
   - Keep legacy version as backup until migration is complete

**Current Status**: 9.4% complete (3/32 screens modernized)
- ✅ Authentication: Login, Organization Selection
- ✅ Dashboard: Modern responsive dashboard
- 🔄 Pending: All CRM modules (Accounts, Contacts, Leads, etc.)

**Modern Folder Structure**:
```
lib/ui/screens/modern/
├── authentication/     # Modern auth screens
├── dashboard_screen.dart
└── shared/            # Common components
```

## Configuration Notes

- **Firebase**: Integrated for analytics (configuration in `android/app/google-services.json`)
- **Android**: Min SDK 23, Target SDK 35
- **iOS**: Deployment target 11.0
- **Dependencies**: Key packages include `flutter_svg`, `http`, `shared_preferences`, `firebase_core`, `connectivity_plus`, `file_picker`, `flutter_quill`, `google_sign_in`

## Google Sign-In Configuration

### Android Setup
- **SHA-1 Fingerprint**: `67:C4:BE:5A:97:39:47:0B:40:2C:14:05:F1:81:AB:C7:E6:CF:A7:DF`
- **Package Name**: `io.bottlecrm`
- **Google Services**: Configured in `android/app/google-services.json`
- **OAuth Client**: Android client type with SHA-1 certificate hash

### API Integration
- **Endpoint**: `/auth/google/`
- **Method**: POST with `idToken` parameter
- **Flow**: Google OAuth → ID Token → Backend verification → JWT token

### Environment Configuration
Use `ApiConfig` class to manage different API URLs:
```dart
// Check current environment
ApiConfig.getCurrentEnvironment(); // "Development" or "Production"

// Get current API URL
ApiConfig.getApiUrl(); 

// Override API URL (optional)
ApiConfig.setApiUrl('https://custom-api.com/api/');
```

## Testing

- **Location**: `test/` directory
- **Focus**: Authentication and validation testing
- **Command**: `flutter test`