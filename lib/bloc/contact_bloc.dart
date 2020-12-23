import 'dart:convert';
import 'package:flutter_crm/model/company.dart';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';

class ContactBloc {
  List<Contact> _contacts = [];
  List _contactsObjForDropdown = [];
  List<Team> _teams = [];
  List _teamsObjForDropdown = [];

  Contact _currentContact;

  Map _currentEditContact = {
    'id': 0,
    'first_name': "",
    'last_name': "",
    'email': "",
    'phone': "",
    'address': {},
    'description': "",
    'assigned_to': [],
    'created_by': Profile(),
    'created_on': "",
    'created_on_arrow': "",
    'is_active': false,
    'teams': [],
    'company': Company()
  };

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

  updateCurrentEditContact(Contact editContact) {
    List teams = [];
    List assignedUsers = [];
    // List<String> profilePicList = [];

    editContact.teams.forEach((team) {
      Map _team = {};
      _team['id'] = team.id;
      _team['name'] = team.name;
      teams.add(_team);
    });

    editContact.assignedTo.forEach((user) {
      Map _user = {};
      _user['id'] = user.id;
      _user['name'] = user.firstName + ' ' + user.lastName;
      assignedUsers.add(_user);
    });

    _currentEditContact['id'] = editContact.id;
    _currentEditContact['first_name'] = editContact.firstName;
    _currentEditContact['last_name'] = editContact.lastName;
    _currentEditContact['email'] = editContact.email;
    _currentEditContact['phone'] = editContact.phone;
    _currentEditContact['description'] = editContact.description;
    _currentEditContact['created_by'] = editContact.createdBy;
    _currentEditContact['created_on'] = editContact.createdOn;
    _currentEditContact['is_active'] = editContact.isActive;
    _currentEditContact['company'] = editContact.company;

    _currentEditContact['created_on_arrow'] = editContact.createdOnText;
    _currentEditContact['teams'] = teams;
    _currentEditContact['assigned_to'] = assignedUsers;
  }

  Map get currentEditContact {
    return _currentEditContact;
  }

  set currentEditContact(currentEditContact) {
    _currentEditContact = currentEditContact;
  }

  List<Contact> get contacts {
    return _contacts;
  }

  Contact get currentContact {
    return _currentContact;
  }

  set currentContact(contact) {
    _currentContact = contact;
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
