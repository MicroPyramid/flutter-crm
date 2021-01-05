import 'dart:convert';
import 'package:flutter_crm/bloc/lead_bloc.dart';
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
  String _currentEditContactId;

  Contact _currentContact;

  List countriesList = leadBloc.countriesList;

  Map _currentEditContact = {
    'first_name': "",
    'last_name': "",
    'email': "",
    'phone': "",
    'address': {
      "address_line": "",
      "street": "",
      "city": "",
      "state": "",
      "postcode": "",
      "country": ""
    },
    'description': "",
    'assigned_to': [],
    'teams': [],
  };

  Future fetchContacts() async {
    _contacts.clear();
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
      print("fetchContacts Error>> $onError");
    });
  }

  cancelCurrentEditContact() {
    _currentEditContactId = null;
    _currentEditContact = {
      'first_name': "",
      'last_name': "",
      'email': "",
      'phone': "",
      'address': {
        "address_line": "",
        "street": "",
        "city": "",
        "state": "",
        "postcode": "",
        "country": ""
      },
      'description': "",
      'assigned_to': [],
      'teams': [],
    };
  }

  updateCurrentEditContact(Contact editContact) {
    _currentEditContactId = editContact.id.toString();
    List teams = [];
    List assignedUsers = [];
    // List<String> profilePicList = [];

    editContact.teams.forEach((team) {
      teams.add(team.id);
    });

    editContact.assignedTo.forEach((user) {
      assignedUsers.add(user.id);
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
    _currentEditContact['address'] = editContact.address;
    countriesList.forEach((country) {
      if (country[0] == editContact.address['country']) {
        _currentEditContact['address']['country'] = country[1];
      }
    });

    // _currentEditContact['created_on_arrow'] = editContact.createdOnText;
    _currentEditContact['teams'] = teams;
    _currentEditContact['assigned_to'] = assignedUsers;

    print(_currentEditContact);
  }

  createContact() async {
    Map result;
    print(currentEditContact);

    currentEditContact['teams'] = (currentEditContact['teams']
        .map((team) => team.toString())).toList().toString();
    currentEditContact['assigned_to'] = (currentEditContact['assigned_to']
        .map((team) => team.toString())).toList().toString();

    Map copyOfCurrentEditContact = {
      'first_name': currentEditContact['first_name'],
      'last_name': currentEditContact['last_name'],
      'phone': currentEditContact['phone'],
      'email': currentEditContact['email'],
      'teams': currentEditContact['teams'],
      'assigned_to': currentEditContact['assigned_to'],
      'address_line': (currentEditContact['address'])['address_line'],
      'street': currentEditContact['address']['street'],
      'city': currentEditContact['address']['city'],
      'state': currentEditContact['address']['state'],
      'postcode': currentEditContact['address']['postcode'],
      'country': currentEditContact['address']['country'],
      'description': currentEditContact['description'],
      // 'contact_attachment' : '',
    };

    print(copyOfCurrentEditContact);

    await CrmService()
        .createContact(copyOfCurrentEditContact)
        .then((response) async {
      var res = json.decode(response.body);

      if (res["error"] != null || res["error"] != "") {
        if (res['error'] == false) {
          await fetchContacts();
          cancelCurrentEditContact();
        }
      }
      result = res;
      print("createContact Response >> \n $res");
    }).catchError((onError) {
      print('createContact Error >> $onError');
    });
    return result;
  }

  editContact() async {
    Map _result;
    print(currentEditContact);
    Map copyOfCurrentEditContact = {
      'first_name': currentEditContact['first_name'],
      'last_name': currentEditContact['last_name'],
      'phone': currentEditContact['phone'],
      'email': currentEditContact['email'],
      'teams': currentEditContact['teams'],
      'assigned_to': currentEditContact['assigned_to'],
      'address_line': (currentEditContact['address'])['address_line'],
      'street': currentEditContact['address']['street'],
      'city': currentEditContact['address']['city'],
      'state': currentEditContact['address']['state'],
      'postcode': currentEditContact['address']['postcode'],
      'country': currentEditContact['address']['country'],
      'description': currentEditContact['description'],
      // 'contact_attachment' : '',
    };
    countriesList.forEach((country) {
      if (country[1] == copyOfCurrentEditContact['country']) {
        copyOfCurrentEditContact['country'] = country[0];
      }
    });

    copyOfCurrentEditContact['teams'] =
        jsonEncode(copyOfCurrentEditContact['teams']);
    copyOfCurrentEditContact['assigned_to'] =
        jsonEncode(copyOfCurrentEditContact['assigned_to']);

    print(copyOfCurrentEditContact);

    await CrmService()
        .editContact(copyOfCurrentEditContact, currentEditContactId)
        .then((response) async {
      var res = json.decode(response.body);

      if (res['error'] != null) {
        cancelCurrentEditContact();
        // res['error'] = true;
      } else {
        await fetchContacts();
      }
      _result = res;
      print("createLead Response >> $res");
    }).catchError((onError) {
      print('editContact Error >> $onError');
      _result = {"status": "error", "message": "Something went wrong."};
    });
    return _result;
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

  String get currentEditContactId {
    return _currentEditContactId;
  }

  List get teamsObjForDropdown {
    return _teamsObjForDropdown;
  }
}

final contactBloc = ContactBloc();
