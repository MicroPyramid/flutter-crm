import 'dart:convert';
import 'dart:io';
import 'package:bottle_crm/bloc/account_bloc.dart';
import 'package:bottle_crm/bloc/lead_bloc.dart';
import 'package:bottle_crm/model/contact.dart';
import 'package:bottle_crm/model/team.dart';
import 'package:bottle_crm/services/crm_services.dart';
import 'package:intl/intl.dart';

import 'dashboard_bloc.dart';

class ContactBloc {
  List<Contact> _contacts = [];
  List _contactsObjForDropdown = [];
  List<Team> _teams = [];
  List _teamsObjForDropdown = [];
  String? _currentEditContactId;
  Contact? _currentContact;
  int? _currentContactIndex;
  List<String?> countriesList = accountBloc.countriesList;
  List _assignedToList = [];

  Map _currentEditContact = {
    'salutation': "",
    'first_name': "",
    'last_name': "",
    'primary_email': "",
    'mobile_number': "",
    'date_of_birth': DateFormat("yyyy-MM-dd")
        .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())),
    'organization': "",
    'department': "",
    'do_not_call': false,
    'title': "",
    'address': {
      "address_line": "",
      "street": "",
      "city": "",
      "state": "",
      "pincode": "",
      "country": ""
    },
    'linked_in_url': "",
    'facebook_url': "",
    'twitter_username': "",
    'description': "",
    'assigned_to': [],
    'teams': [],
  };
  String _offset = "";

  Future fetchContacts({filtersData}) async {
    Map? _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;
    if (filtersData != null) {
      _copyFiltersData!['assigned_to'] =
          _copyFiltersData['assigned_to'].length > 0
              ? jsonEncode(_copyFiltersData['assigned_to'])
              : "";
    }
    await CrmService()
        .getContacts(queryParams: _copyFiltersData, offset: _offset)
        .then((response) {
      var res = json.decode(response.body);
      // _contacts.clear();
      _contactsObjForDropdown.clear();
      _teams.clear();
      _assignedToList.clear();
      res['contact_obj_list'].forEach((_contact) {
        leadBloc.countriesList!.forEach((country) {
          if (_contact!['address'] != null &&
              _contact['address']['country'] != null &&
              _contact['address']['country'] == country[0]) {
            _contact!['address']['country'] = country[1];
          }
        });
        Contact contact = Contact.fromJson(_contact);
        _contacts.add(contact);
      });

      _offset = res['offset'] != null && res['offset'].toString() != "0"
          ? res['offset'].toString()
          : "";

      _contacts.forEach((_contact) {
        Map contact = {};
        contact['id'] = _contact.id;
        contact['name'] = _contact.firstName! + ' ' + _contact.lastName!;
        _contactsObjForDropdown.add(contact);
      });
      if (res['teams'] != null)
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
      // if (res['users'] != null)
      //   res['users'].forEach((_user) {
      //     Profile user = Profile.fromJson(_user);
      //     _assignedToList.add({"name": user.firstName, "id": user.id});
      //   });
    }).catchError((onError) {
      print("fetchContacts Error>> $onError");
    });
  }

  createContact({File? file}) async {
    Map result = {};
    leadBloc.countriesList!.forEach((country) {
      if (country[1] == _currentEditContact['address']['country']) {
        _currentEditContact['address']['country'] = country[0];
      }
    });
    // Map _copyOfCurrentEditContact= new Map.from(_currentEditContact);
    Map _contact = {
      'salutation': _currentEditContact['salutation'],
      'first_name': _currentEditContact['first_name'],
      'last_name': _currentEditContact['last_name'],
      'mobile_number': _currentEditContact['mobile_number'],
      'primary_email': _currentEditContact['primary_email'],
      'title': _currentEditContact['title'],
      'linked_in_url': _currentEditContact['linked_in_url'],
      'facebook_url': _currentEditContact['facebook_url'],
      'twitter_username': _currentEditContact['twitter_username'],
      'organization': _currentEditContact['organization'],
      'department': _currentEditContact['department'],
      'date_of_birth': _currentEditContact['date_of_birth'],
      'do_not_call': _currentEditContact['do_not_call'],
      'teams': _currentEditContact['teams'],
      'assigned_to': _currentEditContact['assigned_to'],
      'address_line': (_currentEditContact['address'])['address_line'],
      'street': _currentEditContact['address']['street'],
      'city': _currentEditContact['address']['city'],
      'state': _currentEditContact['address']['state'],
      'pincode': _currentEditContact['address']['pincode'],
      'country': _currentEditContact['address']['country'],
      'description': _currentEditContact['description'],
      // 'contact_attachment' : '',
    };

    _contact['teams'] =
        (_contact['teams'].map((team) => team.toString())).toList().toString();
    _contact['assigned_to'] = (_contact['assigned_to']
        .map((team) => team.toString())).toList().toString();
    _contact['do_not_call'] = _contact['do_not_call'].toString();
    await CrmService().createContact(_contact, file!).then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        //await fetchContacts();
        await dashboardBloc.fetchDashboardDetails();
      }
      result = res;
    }).catchError((onError) {
      print('createContact Error >> $onError');
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  editContact() async {
    Map? _result;
    Map copyOfCurrentEditContact = {
      'salutation': _currentEditContact['salutation'],
      'first_name': _currentEditContact['first_name'],
      'last_name': _currentEditContact['last_name'],
      'mobile_number': _currentEditContact['mobile_number'],
      'primary_email': _currentEditContact['primary_email'],
      'title': _currentEditContact['title'],
      'linked_in_url': _currentEditContact['linked_in_url'],
      'facebook_url': _currentEditContact['facebook_url'],
      'twitter_username': _currentEditContact['twitter_username'],
      'organization': _currentEditContact['organization'],
      'department': _currentEditContact['department'],
      'date_of_birth': _currentEditContact['date_of_birth'],
      'do_not_call': _currentEditContact['do_not_call'],
      'teams': _currentEditContact['teams'],
      'assigned_to': _currentEditContact['assigned_to'],
      'address_line': (_currentEditContact['address'])['address_line'],
      'street': _currentEditContact['address']['street'],
      'city': _currentEditContact['address']['city'],
      'state': _currentEditContact['address']['state'],
      'pincode': _currentEditContact['address']['pincode'],
      'country': _currentEditContact['address']['country'],
      'description': _currentEditContact['description'],
      // 'contact_attachment' : '',
    };
    countriesList.forEach((country) {
      if (country![1] == copyOfCurrentEditContact['country']) {
        copyOfCurrentEditContact['country'] = country[0];
      }
    });

    copyOfCurrentEditContact['teams'] =
        jsonEncode(copyOfCurrentEditContact['teams']);
    copyOfCurrentEditContact['assigned_to'] =
        jsonEncode(copyOfCurrentEditContact['assigned_to']);
    await CrmService()
        .editContact(copyOfCurrentEditContact, currentEditContactId)
        .then((response) async {
      var res = json.decode(response.body);

      if (res['error'] == false) {
        await fetchContacts();
        await dashboardBloc.fetchDashboardDetails();
      }
      _result = res;
    }).catchError((onError) {
      print('editContact Error >> $onError');
      _result = {"status": "error", "message": onError};
    });
    return _result;
  }

  Future deleteContact(Contact contact) async {
    Map? result;
    await CrmService().deleteContact(contact.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchContacts();
      await dashboardBloc.fetchDashboardDetails();
      result = res;
    }).catchError((onError) {
      print("deleteContact Error >> $onError");
      result = {"status": "error", "message": onError};
    });
    return result;
  }

  cancelCurrentEditContact() {
    _currentEditContactId = null;
    _currentEditContact = {
      'salutation': "",
      'first_name': "",
      'last_name': "",
      'primary_email': "",
      'mobile_number': "",
      'title': "",
      'linked_in_url': '',
      'facebook_url': '',
      'twitter_username': '',
      'organization': '',
      'department': '',
      'date_of_birth': DateFormat("yyyy-MM-dd")
          .format(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())),
      'do_not_call': false,
      'address': {
        "address_line": "",
        "street": "",
        "city": "",
        "state": "",
        "pincode": "",
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

    editContact.teams!.forEach((team) {
      teams.add(team.id);
    });

    editContact.assignedTo!.forEach((user) {
      assignedUsers.add(user.id);
    });
    _currentEditContact['salutation'] = editContact.salutation;
    _currentEditContact['id'] = editContact.id;
    _currentEditContact['first_name'] = editContact.firstName;
    _currentEditContact['last_name'] = editContact.lastName;
    _currentEditContact['primary_email'] = editContact.primaryEmail;
    _currentEditContact['mobile_number'] = editContact.primaryMobile;
    _currentEditContact['title'] = editContact.title;
    _currentEditContact['linked_in_url'] = editContact.linkedInUrl;
    _currentEditContact['facebook_url'] = editContact.facebookUrl;
    _currentEditContact['twitter_username'] = editContact.twitterUserName;
    _currentEditContact['organization'] = editContact.organization;
    _currentEditContact['department'] = editContact.department;
    _currentEditContact['date_of_birth'] = editContact.dateOfBirth;
    _currentEditContact['do_not_call'] = editContact.doNotCall;
    _currentEditContact['description'] = editContact.description;
    _currentEditContact['created_by'] = editContact.createdBy;
    _currentEditContact['created_on'] = editContact.createdOn;
    _currentEditContact['is_active'] = editContact.isActive;
    _currentEditContact['address'] = editContact.address;
    countriesList.forEach((country) {
      if (country![0] == editContact.address!['country']) {
        _currentEditContact['address']['country'] = country[1];
      }
    });
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

  Contact? get currentContact {
    return _currentContact;
  }

  set currentContact(contact) {
    _currentContact = contact;
  }

  int? get currentContactIndex {
    return _currentContactIndex;
  }

  set currentContactIndex(currentContactIndex) {
    _currentContactIndex = currentContactIndex;
  }

  List<Team> get teams {
    return _teams;
  }

  List get contactsObjForDropdown {
    return _contactsObjForDropdown;
  }

  String? get currentEditContactId {
    return _currentEditContactId;
  }

  set currentEditContactId(id) {
    _currentEditContactId = id;
  }

  List get teamsObjForDropdown {
    return _teamsObjForDropdown;
  }

  List get assignedToList {
    return _assignedToList;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }
}

final contactBloc = ContactBloc();
