import 'dart:convert';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

class UserBloc {
  List<Profile> _users = [];

  List<Profile> get users {
    return _users;
  }
}

final userBloc = UserBloc();
