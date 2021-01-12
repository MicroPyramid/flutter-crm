import 'dart:convert';

import 'package:flutter_crm/model/document.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

class DocumentBloc {
  List<Document> _activeDocuments = [];
  List<Document> _inActiveDocuments = [];
  List<Document> _documents = [];
  List _fileSizes = [];

  List _statusObjforDropdown = [];
  List<Map> _usersObjforMultiselect = [];

  Map _currentEditDocument = {'title': "", 'teams': [], 'shared_to': []};
  String _currentEditDocumentId;

  fetchDocuments() async {
    await CrmService().getDocuments().then((response) async {
      _activeDocuments.clear();
      _inActiveDocuments.clear();
      _documents.clear();
      _fileSizes.clear();

      var res = jsonDecode(response.body);

      res['documents_active'].forEach((_document) {
        Document document = Document.fromJson(_document);
        _activeDocuments.add(document);
        _documents.add(document);
      });
      res['documents_inactive'].forEach((_document) {
        Document document = Document.fromJson(_document);
        _inActiveDocuments.add(document);
        _documents.add(document);
      });

      res['status_choices'].map((status) {
        _statusObjforDropdown.add(status);
      });

      res['users'].forEach((_user) {
        Profile user = Profile.fromJson(_user);
        Map data = {};
        data['id'] = user.id;
        data['name'] = "${user.firstName} ${user.lastName}";
        _usersObjforMultiselect.add(data);
      });
    }).catchError((onError) {
      print('fetchDocuments Error >> $onError');
    });

    // _fileSizes = await CrmService().getFileSizes(_documents);
  }

  createDocument(file) async {
    Map _copyOfCurrentEditDocument = Map.from(_currentEditDocument);
    _copyOfCurrentEditDocument['teams'] = (_copyOfCurrentEditDocument['teams']
        .map((team) => team.toString())).toList().toString();
    _copyOfCurrentEditDocument['shared_to'] =
        (_copyOfCurrentEditDocument['shared_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    print(_copyOfCurrentEditDocument);
    await CrmService()
        .createDocument(_copyOfCurrentEditDocument, file)
        .then((response) {
      // var res = jsonDecode(response.body);
      print(response);
      if (response.statusCode == 200) {
        print('UPLOAD SUCCESSFUL');
      } else {
        print("${response.reasonPhrase} UPLOAD UNSUCCESSFUL");
      }
    });
  }

  List get documents {
    return _documents;
  }

  List get activeDocuments {
    return _activeDocuments;
  }

  List get inActiveDocuments {
    return _inActiveDocuments;
  }

  List get fileSizes {
    return _fileSizes;
  }

  List get statusObjforDropdown {
    return _statusObjforDropdown;
  }

  List get usersObjforMultiselect {
    return _usersObjforMultiselect;
  }

  String get currentEditDocumentId {
    return _currentEditDocumentId;
  }

  Map get currentEditDocument {
    return _currentEditDocument;
  }

  set currentEditDocumentId(id) {
    _currentEditDocumentId = id;
  }
  // --------------------------DOCUMENT DOWNLOAD METHODS----------------

}

final documentBLoc = DocumentBloc();
