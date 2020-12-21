import 'dart:convert';
import 'package:flutter_crm/model/team.dart';
import 'package:flutter_crm/services/crm_services.dart';

class TeamBloc {
  List<Team> _teams = [];

  Future fetchTeams() async {
    await CrmService().getTeams().then((response) {
      // var res = json.decode(response.body);
      // print("Teams Fetched");
      // print(res.runtimeType);
      // print(res);

      // res['teams'].forEach((team) {
      //   _teams.add(team);
      // });
    });
  }

  List<Team> get teams {
    return _teams;
  }
}

final teamBloc = TeamBloc();
