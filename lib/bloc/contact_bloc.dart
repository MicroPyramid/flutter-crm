import 'dart:convert';
import 'package:flutter_crm/model/contact.dart';
import 'package:flutter_crm/services/crm_services.dart';

class ContactBloc {
  List<Contact> _contacts = [];

  Future fetchContacts() async {
    await CrmService().getContacts().then((response) {
      var res = (json.decode(response.body));

      res['contact_obj_list'].forEach((_contact) {
        Contact contact = Contact.fromJson(_contact);
        _contacts.add(contact);
      });
    }).catchError((onError) {
      print("fetchContacts>> $onError");
    });
  }

  List<Contact> get contacts {
    return _contacts;
  }
}

final contactBloc = ContactBloc();
