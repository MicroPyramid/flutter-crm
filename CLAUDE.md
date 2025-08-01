# BottleCRM - Claude Context

## Project Overview
- **Name**: BottleCRM
- **Platform**: Flutter
- **Version**: 1.0.0+1
- **Flutter SDK**: ^3.8.1
- **Design System**: Material Design
- **Icons**: Material Icons
- **Architecture**: Modern Flutter best practices

## Project Structure
- `/lib/` - Main Dart source code
- `/assets/` - Application assets (images, icons, fonts)
- `/android/` - Android-specific configuration
- `/ios/` - iOS-specific configuration
- `/web/` - Web platform configuration
- `/test/` - Unit and widget tests

## Development Guidelines

### Design & UI/UX
- Follow Material Design 3 principles
- Implement modern UI/UX best practices
- Maintain consistency across all screens
- Use responsive design for different screen sizes

#### Card & List Styling Guidelines
- **Flat Design**: Use flat, minimal card styling similar to Asana/Jira
- **No Shadows**: Avoid Card elevation/shadows; use Container with borders instead
- **AppBar Styling**: Keep AppBars transparent/white (no backgroundColor: inversePrimary)
- **List Items**: Use bottom borders (Colors.grey.shade200) for item separation
- **Dashboard Cards**: White background with subtle grey borders and 8px border radius
- **Task Cards**: Add left border with priority color (3px width) for visual hierarchy
- **Consistent Spacing**: Use 4px vertical margins for list items, 16px horizontal margins

#### Color Guidelines
- **Borders**: Use Colors.grey.shade200 for subtle separators
- **Priority Colors**: Green (low), Orange (medium), Red (high), Purple (urgent)
- **Status Colors**: Blue (new), Orange (contacted), Green (qualified), Red (lost)
- **Backgrounds**: White containers with minimal border styling

### Code Standards
- Follow Dart/Flutter naming conventions
- Use descriptive variable and function names
- Implement proper error handling
- Write clean, maintainable code
- Add appropriate comments for complex logic

### File & Folder Structure
- Organize files by feature/module
- Use proper naming conventions (snake_case for files)
- Keep related files grouped together
- Maintain clear separation of concerns

### Dependencies
- **Core**: Flutter SDK, Cupertino Icons
- **Development**: Flutter Test, Flutter Lints, Flutter Launcher Icons
- **Linting**: Enabled via analysis_options.yaml

## Common Commands
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Build for release
flutter build apk --release
flutter build ios --release

# Generate icons
flutter pub run flutter_launcher_icons:main

# Analyze code
flutter analyze

# Format code
dart format .
```

## Key Features to Implement
- CRM functionality (contacts, leads, deals)
- User authentication and authorization
- Data synchronization
- Offline capability
- Modern dashboard with analytics
- Mobile-optimized user interface

## Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Use flutter_test framework

## API Architecture
- **Centralized URLs**: All API endpoints defined in `lib/config/api_config.dart`
- **HTTP Service**: Unified REST client in `lib/services/api_service.dart`
- **Authentication**: Google Sign-In + JWT tokens via `lib/services/auth_service.dart`
- **Models**: Type-safe API response models in `lib/models/api_models.dart`
- **Usage Examples**: See `lib/services/example_usage.dart` for implementation patterns

### API Usage Pattern
```dart
// Get data from API
final response = await ApiService().get(ApiConfig.contacts);
if (response.success) {
  final contacts = response.data!.map((json) => Contact.fromJson(json)).toList();
}

// Authentication check
if (AuthService().isLoggedIn) {
  // Make authenticated requests
}
```

## Dependencies Added
- `http: ^1.1.0` - HTTP client for API calls
- `google_sign_in: ^6.1.5` - Google authentication
- `shared_preferences: ^2.2.2` - Local storage for tokens
- `jwt_decoder: ^2.0.1` - JWT token handling

## Notes for AI Assistant
- Always use centralized API URLs from `ApiConfig`
- All REST requests must go through `ApiService`
- Handle authentication automatically via `AuthService`
- Use type-safe models for all API responses
- Follow Material Design guidelines
- Maintain consistent code style across the project
- Implement proper state management
- Consider mobile-first design principles
- Ensure accessibility compliance
- Use Flutter best practices for performance