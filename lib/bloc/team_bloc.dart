import 'dart:convert';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';

class TeamBloc {
  List<Team> _teams = [];

  List<Team> get teams {
    return _teams;
  }
}

final teamBloc = TeamBloc();
