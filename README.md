# BottleCRM Mobile

A Flutter-based mobile CRM application for startups and enterprises. This app provides comprehensive customer relationship management features including account management, lead tracking, opportunity pipeline, task management, and more.

## Features

- **Google Sign-In**: Secure OAuth-based authentication
- **Dashboard**: Overview of CRM metrics and recent activities
- **Accounts**: Customer account management
- **Contacts**: Contact information and communication history
- **Leads**: Lead tracking and conversion pipeline
- **Opportunities**: Sales opportunity management
- **Cases**: Customer support case tracking
- **Tasks**: Task management and assignments
- **Events**: Calendar and event scheduling
- **Documents**: File management and sharing
- **Teams**: Team collaboration tools
- **Users**: User management and permissions
- **Invoices**: Billing and invoice generation

## Requirements

- Flutter SDK 3.32.8 or later
- Dart SDK 3.0.0 or later
- Android SDK (API level 23+)
- iOS 11.0+ (for iOS builds)

## Getting Started

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd bottlecrm_mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Google Sign-In:
   - Add your `google-services.json` to `android/app/`
   - Configure Google Cloud Console with SHA-1 fingerprint
   - Set up OAuth consent screen

### Development

```bash
# Run the app in debug mode
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Build

```bash
# Clean previous builds
flutter clean
flutter pub get

# Build for Android
flutter build appbundle  # For Play Store
flutter build apk        # For direct installation

# Build for iOS (macOS only)
flutter build ios
```

## Architecture

The app follows a modular architecture with:

- **Custom BLoC Pattern**: State management using singleton BLoC instances
- **Modular Structure**: Consistent patterns across all CRM modules
- **Responsive Design**: Adaptive UI for mobile, tablet, and desktop
- **API Integration**: RESTful API communication with JWT authentication

For detailed architecture information, see [CLAUDE.md](CLAUDE.md).

## Configuration

### API Configuration
The app uses environment-based API URLs:
- **Development**: `http://localhost:3000/` (debug builds)
- **Production**: `https://api.bottlecrm.io/api/` (release builds)

### Authentication
- **Google OAuth**: Primary authentication method
- **JWT Tokens**: Backend authentication after Google sign-in
- **Storage**: SharedPreferences for local token storage

### Google Sign-In Setup

1. **Get SHA-1 fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   ```

2. **Google Cloud Console**:
   - Create OAuth 2.0 Client ID for Android

3. **Firebase Console**:
   - Enable Google Sign-In provider
   - Download updated `google-services.json`

### Multi-tenancy
- Organization-based data isolation
- Organization header support in API requests

## License

Free CRM for startups and enterprises.
