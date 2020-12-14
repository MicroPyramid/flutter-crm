import 'dart:convert';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';

class ContactBloc {
  List<Contact> _contacts = [];
  List _contactsObjForDropdown = [];
  List<Team> _teams = [];
  List _teamsObjForDropdown = [];

  Future fetchContacts() async {
    await CrmService().getContacts().then((response) {
      var res = (json.decode(response.body));

      res['contact_obj_list'].forEach((_contact) {
        Contact contact = Contact.fromJson(_contact);
        _contacts.add(contact);
      });

      _contacts.forEach((_contact) {
        Map contact = {};
        contact['id'] = _contact.id;
        contact['name'] = _contact.firstName + ' ' + _contact.lastName;
        _contactsObjForDropdown.add(contact);
      });

      res['teams'].forEach((_team) {
        Team team = Team.fromJson(_team);
        _teams.add(team);
      });

      _teams.forEach((_team) {
        Map team = {};
        team['id'] = _team.id;
        team['name'] = _team.name;
        _teamsObjForDropdown.add(team);
      });
    }).catchError((onError) {
      print("fetchContacts>> $onError");
    });
  }

  List<Contact> get contacts {
    return _contacts;
  }

  List<Team> get teams {
    return _teams;
  }

  List get contactsObjForDropdown {
    return _contactsObjForDropdown;
  }

  List get teamsObjForDropdown {
    return _teamsObjForDropdown;
  }
}

final contactBloc = ContactBloc();
