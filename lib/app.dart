import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/company_selection_screen.dart';
import 'screens/company_create_screen.dart';
import 'screens/lead_detail_screen.dart';
import 'screens/lead_create_screen.dart';
import 'screens/contacts_list_screen.dart';
import 'screens/contact_create_screen.dart';
import 'screens/contact_detail_screen.dart';
import 'screens/tasks_list_screen.dart';
import 'screens/task_create_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/task_edit_screen.dart';
import 'screens/about_screen.dart';
import 'screens/help_support_screen.dart';
import 'services/auth_service.dart';
import 'services/leads_service.dart';

class BottleCrmApp extends StatelessWidget {
  const BottleCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottleCRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Blue color for CRM
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/company-selection': (context) => const CompanySelectionScreen(),
        '/company-create': (context) => const CompanyCreateScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/about': (context) => const AboutScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
        '/contacts': (context) => const ContactsListScreen(),
        '/contact-create': (context) => const ContactCreateScreen(),
        '/contact-detail': (context) {
          final contactId =
              ModalRoute.of(context)!.settings.arguments as String;
          return ContactDetailScreen(contactId: contactId);
        },
        '/lead-detail': (context) {
          final leadId = ModalRoute.of(context)!.settings.arguments as String;
          return LeadDetailScreen(leadId: leadId);
        },
        '/lead-create': (context) => const LeadCreateScreen(),
        '/tasks': (context) => const TasksListScreen(),
        '/task-create': (context) => const TaskCreateScreen(),
        '/task-detail': (context) {
          final taskId = ModalRoute.of(context)!.settings.arguments as String;
          return TaskDetailScreen(taskId: taskId);
        },
        '/task-edit': (context) {
          final taskId = ModalRoute.of(context)!.settings.arguments as String;
          return TaskEditScreen(taskId: taskId);
        },
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  final LeadsService _leadsService = LeadsService();
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _authService.initialize();
      await _leadsService.initialize();
    } catch (e) {
      debugPrint('Auth initialization error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading BottleCRM...'),
              ],
            ),
          ),
        ),
      );
    }

    // Check authentication status and organization selection
    if (!_authService.isLoggedIn) {
      return const LoginScreen();
    }

    // If logged in but no organization selected, show company selection
    if (!_authService.hasSelectedOrganization) {
      return const CompanySelectionScreen();
    }

    // If logged in and organization selected, show dashboard
    return const DashboardScreen();
  }
}
