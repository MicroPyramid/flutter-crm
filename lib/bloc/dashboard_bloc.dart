import 'dart:convert';
import 'package:bottle_crm/model/account.dart';
import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/opportunities.dart';
import 'package:bottle_crm/services/crm_services.dart';

class DashboardBloc {
  Map _dashboardData = {};

  Future fetchDashboardDetails() async {
    await CrmService().getDashboardDetails().then((response) {
      var res = (json.decode(response.body));

      List<Account> _accounts = [];
      List<Opportunity> _opportunities = [];
      List<Contact> _contacts = [];

      res['accounts'].forEach((_account) {
        Account account = Account.fromJson(_account);
        _accounts.add(account);
      });

      res['contacts'].forEach((_contact) {
        Contact contact = Contact.fromJson(_contact);
        _contacts.add(contact);
      });

      res['opportunities'].forEach((_opportunity) {
        Opportunity opportunity = Opportunity.fromJson(_opportunity);
        _opportunities.add(opportunity);
      });

      _dashboardData['accounts'] = _accounts;
      _dashboardData['opportunities'] = _opportunities;
      _dashboardData['contacts'] = _contacts;
      _dashboardData['accountsCount'] = res['accounts_count'];
      _dashboardData['contactsCount'] = res['contacts_count'];
      _dashboardData['leadsCount'] = res['leads_count'];
      _dashboardData['opportunitiesCount'] = res['opportunities_count'];
    });
    // .catchError((onError) {
    //   print("fetchDashboardDetails Error >> $onError");
    // });
  }

  Map get dashboardData {
    return _dashboardData;
  }
}

final dashboardBloc = DashboardBloc();
