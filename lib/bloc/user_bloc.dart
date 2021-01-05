import 'package:flutter_crm/model/profile.dart';

class UserBloc {
  List<Profile> _users = [];

  List<Profile> get users {
    return _users;
  }
}

final userBloc = UserBloc();
