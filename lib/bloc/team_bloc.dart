import 'dart:convert';

import 'package:bottle_crm/model/team.dart';
import 'package:bottle_crm/services/crm_services.dart';

class TeamBloc {
  List<Team> _teams = [];
  List<List> _users = [];
  List<String?> _usersObjForDropDown = [];
  List _teamsObjForDropdown = [];
  Map? _currentEditTeam = {
    'name': "",
    'description': "",
    'assign_users': [],
  };
  String? _currentEditTeamId;
  Team? _currentTeam;
  int? _currentTeamIndex;
  String _offset = "";

  Future fetchTeams({filtersData}) async {
    Map? _copyFiltersData =
        filtersData != null ? new Map.from(filtersData) : null;
    if (_copyFiltersData != null) {
      _users.forEach((e) {
        if (_copyFiltersData['created_by'] != null) {
          if (e[1] == _copyFiltersData['created_by']) {
            _copyFiltersData['created_by'] = e[0].toString();
          }
        }
      });
      if (_copyFiltersData['assigne_users'].length != 0) {
        _copyFiltersData['assigne_users'] = (_copyFiltersData['assigne_users']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
      }
    }

    await CrmService().getTeams(queryParams: _copyFiltersData, offset: _offset).then((response) {
      var res = json.decode(response.body);

      _teams.clear();
      _users.clear();
      _usersObjForDropDown.clear();

      res['teams'].forEach((_team) {
        Team team = Team.fromJson(_team);
        _teams.add(team);
      });

      _teams.forEach((_team) {
          Map team = {};
          team['id'] = _team.id;
          team['name'] = _team.name!;
          _teamsObjForDropdown.add(team);
        });
      // res['users'].forEach((_user) {
      //   Profile user = Profile.fromJson(_user);
      //   _users.add([user.id, user.firstName]);
      //   _usersObjForDropDown.add(user.firstName);
      // });
    });
  }

  Future createTeam() async {
    Map? result;
    //print("----");
   // print(_currentEditTeam);
    Map _copyCurrentEditTeam = Map.from(_currentEditTeam!);

    _copyCurrentEditTeam['assign_users'] = (_copyCurrentEditTeam['assign_users']
        .map((assignedTo) => assignedTo.toString())).toList().toString();
  //print("===");
 // print(_copyCurrentEditTeam);
        

    await CrmService().createTeam(_copyCurrentEditTeam).then((response) async {
      print(_copyCurrentEditTeam);
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchTeams();
      }
      result = res;
    });

    print(result)
;    // .catchError((onError) {
    //   print('createTeam Error >> $onError');
    //   result = {"status": "error", "message": "Something went wrong"};
    // });
    return result;
  }

  Future editTeam() async {
    Map? _result;
    Map _copyOfCurrentEditTeam = Map.from(_currentEditTeam!);

    _copyOfCurrentEditTeam['assign_users'] =
        (_copyOfCurrentEditTeam['assign_users']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    await CrmService()
        .editTeam(_copyOfCurrentEditTeam, _currentEditTeamId)
        .then((response) async {
      var res = json.decode(response.body);
      if (res['error'] == false) {
        await fetchTeams();
      }
      _result = res;
    }).catchError((onError) {
      print("editTeam Error >> $onError");
      _result = {"status": "error", "message": "Something went wrong."};
    });
    return _result;
  }

  Future deleteTeam(Team team) async {
    Map? result;
    await CrmService().deleteTeam(team.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchTeams();
      result = res;
    }).catchError((onError) {
      print("deleteTeam Error >> $onError");
      result = {"status": "error", "message": "Something went wrong."};
    });
    return result;
  }

  cancelCurrentEditTeam() {
    _currentEditTeamId = null;
    _currentEditTeam = {
      'name': "",
      'description': "",
      'assign_users': [],
    };
  }

  updateCurrentEditTeam(Team team) {
    List _currUsers = [];
    _currentEditTeamId = team.id.toString();
    _currentEditTeam = {
      'name': team.name,
      'description': team.description,
    };
    team.users!.forEach((element) {
      _currUsers.add(element.id);
    });
    _currentEditTeam!['assign_users'] = _currUsers;
  }

  List<Team> get teams {
    return _teams;
  }

  List<List> get users {
    return _users;
  }

  List<String?> get userObjForDropDown {
    return _usersObjForDropDown;
  }

  List get teamsObjForDropdown {
    return _teamsObjForDropdown;
  }

  Map? get currentEditTeam {
    return _currentEditTeam;
  }

  String? get currentEditTeamId {
    return _currentEditTeamId;
  }

  set currentEditTeamId(id) {
    _currentEditTeamId = id;
  }

  Team? get currentTeam {
    return _currentTeam;
  }

  set currentTeam(team) {
    _currentTeam = team;
  }

  int? get currentTeamIndex {
    return _currentTeamIndex;
  }

  set currentTeamIndex(index) {
    _currentTeamIndex = index;
  }

  String get offset {
    return _offset;
  }

  set offset(offset) {
    _offset = offset;
  }
}

final teamBloc = TeamBloc();
