import 'package:bottle_crm/ui/screens/accounts/accounts_list.dart';
import 'package:bottle_crm/ui/screens/accounts/account_create.dart';
import 'package:bottle_crm/ui/screens/accounts/account_details.dart';
import 'package:bottle_crm/ui/screens/authentication/change_password.dart';
import 'package:bottle_crm/ui/screens/authentication/companies_List.dart';
import 'package:bottle_crm/ui/screens/modern/authentication/organization_selection_screen.dart';
import 'package:bottle_crm/ui/screens/authentication/forgot_password.dart';
import 'package:bottle_crm/ui/screens/authentication/login.dart';
import 'package:bottle_crm/ui/screens/modern/authentication/login_screen.dart';
import 'package:bottle_crm/ui/screens/authentication/profile.dart';
import 'package:bottle_crm/ui/screens/authentication/register.dart';
import 'package:bottle_crm/ui/screens/cases/case_create.dart';
import 'package:bottle_crm/ui/screens/cases/case_details.dart';
import 'package:bottle_crm/ui/screens/cases/cases_list.dart';
import 'package:bottle_crm/ui/screens/contacts/contact_create.dart';
import 'package:bottle_crm/ui/screens/contacts/contact_details.dart';
import 'package:bottle_crm/ui/screens/contacts/contacts_list.dart';
import 'package:bottle_crm/ui/screens/dashboard/dashboard.dart';
import 'package:bottle_crm/ui/screens/modern/dashboard_screen.dart';
import 'package:bottle_crm/ui/screens/documents/documents_list.dart';
import 'package:bottle_crm/ui/screens/events/event_create.dart';
import 'package:bottle_crm/ui/screens/events/event_details.dart';
import 'package:bottle_crm/ui/screens/events/events_list.dart';
import 'package:bottle_crm/ui/screens/invoices/invoices_list.dart';
import 'package:bottle_crm/ui/screens/leads/lead_create.dart';
import 'package:bottle_crm/ui/screens/leads/lead_details.dart';
import 'package:bottle_crm/ui/screens/leads/leads_list.dart';
import 'package:bottle_crm/ui/screens/more_options_screen.dart';
import 'package:bottle_crm/ui/screens/opportunities/opportunitie_create.dart';
import 'package:bottle_crm/ui/screens/opportunities/opportunitie_details.dart';
import 'package:bottle_crm/ui/screens/opportunities/opportunities_list.dart';
import 'package:bottle_crm/ui/screens/settings/settings.dart';
import 'package:bottle_crm/ui/screens/settings/settings_details.dart';
import 'package:bottle_crm/ui/screens/settings/settings_userDetails.dart';
import 'package:bottle_crm/ui/screens/tasks/task_create.dart';
import 'package:bottle_crm/ui/screens/tasks/task_details.dart';
import 'package:bottle_crm/ui/screens/tasks/tasks_list.dart';
import 'package:bottle_crm/ui/screens/teams/team_create.dart';
import 'package:bottle_crm/ui/screens/teams/team_details.dart';
import 'package:bottle_crm/ui/screens/teams/teams_list.dart';
import 'package:bottle_crm/ui/screens/users/user_create.dart';
import 'package:bottle_crm/ui/screens/users/user_details.dart';
import 'package:bottle_crm/ui/screens/users/users_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //static FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver getAnalyticsObserver =
  //     FirebaseAnalyticsObserver(analytics: _analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //navigatorObservers: [getAnalyticsObserver],
      title: 'bottlecrm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme:ButtonThemeData(buttonColor:Color.fromRGBO(62, 121, 247, 1)),
          scaffoldBackgroundColor: Color.fromRGBO(236, 238, 244, 1),
          //buttonColor: Color.fromRGBO(62, 121, 247, 1),
          primaryColor: Color.fromRGBO(62, 121, 247, 1),
          secondaryHeaderColor: Color.fromRGBO(112, 121, 128, 1),
          dividerColor: Color.fromRGBO(69, 85, 96, 1)),
      home: Login(),
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => Scaffold(
              body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('oops! something went wrong.',
                    style: TextStyle(fontSize: 20.0))
              ],
            ),
          )),
        );
      },
      routes: {
        '/login': (BuildContext context) => LoginScreen(), // Modern login
        '/login_legacy': (BuildContext context) => Login(), // Legacy login
        '/register': (BuildContext context) => Register(),
        '/forgot_password': (BuildContext context) => ForgotPassword(),
        '/change_password': (BuildContext context) => ChangePassword(),
        '/profile': (BuildContext context) => Profile(),
        '/dashboard': (BuildContext context) => ModernDashboardScreen(), // Modern dashboard
        '/dashboard_legacy': (BuildContext context) => Dashboard(), // Legacy dashboard
        '/more_options': (BuildContext context) => MoreOptions(),
        '/leads_list': (BuildContext context) => LeadsList(),
        '/leads_create': (BuildContext context) => CreateLead(),
        '/lead_details': (BuildContext context) => LeadDetails(),
        '/accounts_list': (BuildContext context) => AccountsList(),
        '/account_create': (BuildContext context) => CreateAccount(),
        '/account_details': (BuildContext context) => AccountDetails(),
        '/cases_list': (BuildContext context) => CasesList(),
        '/case_details': (BuildContext context) => CaseDetails(),
        '/case_create': (BuildContext context) => CreateCase(),
        '/contacts_list': (BuildContext context) => ContactsList(),
        '/contact_create': (BuildContext context) => CreateContact(),
        '/contact_details': (BuildContext context) => ContactDetails(),
        '/documents_list': (BuildContext context) => DocumentsList(),
        '/events_list': (BuildContext context) => EventsList(),
        '/event_details': (BuildContext context) => EventDetails(),
        '/event_create': (BuildContext context) => CreateEvent(),
        '/invoices_list': (BuildContext context) => InvoicesList(),
        '/opportunitie_create': (BuildContext context) => CreateOpportunities(),
        '/opportunitie_details': (BuildContext context) =>
            OpportunitiesDetails(),
        '/opportunities_list': (BuildContext context) => OpportunitiesList(),
        '/tasks_list': (BuildContext context) => TasksList(),
        '/task_details': (BuildContext context) => TasskDeails(),
        '/task_create': (BuildContext context) => CreateTask(),
        '/teams_list': (BuildContext context) => TeamsList(),
        '/team_create': (BuildContext context) => CreateTeam(),
        '/team_details': (BuildContext context) => TeamkDeails(),
        '/users_list': (BuildContext context) => UsersList(),
        '/user_create': (BuildContext context) => CreateUser(),
        '/user_details': (BuildContext context) => UserDetails(),
        '/organization_selection': (BuildContext context) => OrganizationSelectionScreen(), // Modern org selection
        '/companies_List': (BuildContext context) => CompaniesList(), // Legacy companies list
        '/settings_List': (BuildContext context) => SettingsList(),
        '/settings_details': (BuildContext context) => SettingsDeails(),
        '/settings_userDetails': (BuildContext context) => SettingsUserDetails(),
      },
    );
  }
}
