import 'dart:convert';

import 'package:bottle_crm/model/document.dart';
import 'package:bottle_crm/model/profile.dart';
import 'package:bottle_crm/services/crm_services.dart';

class DocumentBloc {
  List<Document> _activeDocuments = [];
  List<Document> _inActiveDocuments = [];
  List<Document> _documents = [];
  List _fileSizes = [];

  List _statusObjforDropdown = [];
  List<Map> _usersObjforMultiselect = [];

  Document? _currentDocument;
  int? _currentDocumentIndex;
  Map _currentEditDocument = {
    'title': "",
    'teams': [],
    'shared_to': [],
    'document_file': ''
  };
  String? _currentEditDocumentId;

  fetchDocuments({searchData}) async {
    Map? _copySearchData = searchData != null ? new Map.from(searchData) : null;

    await CrmService()
        .getDocuments(queryParams: _copySearchData)
        .then((response) async {
      _activeDocuments.clear();
      _inActiveDocuments.clear();
      _documents.clear();
      _fileSizes.clear();
      _usersObjforMultiselect.clear();

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
        _usersObjforMultiselect.add({
          "name": "${user.firstName} ${user.lastName}",
          "id": user.id.toString()
        });
      });
    }).catchError((onError) {
      print('fetchDocuments Error >> $onError');
    });

    // _fileSizes = await CrmService().getFileSizes(_documents);
    // print(fileSizes);
  }

  createDocument(file) async {
    Map? result;
    Map _copyOfCurrentEditDocument = new Map.from(_currentEditDocument);
    _copyOfCurrentEditDocument['teams'] = (_copyOfCurrentEditDocument['teams']
        .map((team) => team.toString())).toList().toString();
    _copyOfCurrentEditDocument['shared_to'] =
        (_copyOfCurrentEditDocument['shared_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    await CrmService()
        .createDocument(_copyOfCurrentEditDocument, file)
        .then((response) async {
      var res = json.decode(response);
      if (res["error"] == false) {
        await fetchDocuments();
      }
      result = res;
    }).catchError((onError) {
      print("editDocument Error >> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  Future editDocument(file) async {
    Map? result;
    Map _copyOfCurrentEditDocument = Map.from(_currentEditDocument);
    _copyOfCurrentEditDocument['teams'] = (_copyOfCurrentEditDocument['teams']
        .map((team) => team.toString())).toList().toString();
    _copyOfCurrentEditDocument['shared_to'] =
        (_copyOfCurrentEditDocument['shared_to']
            .map((assignedTo) => assignedTo.toString())).toList().toString();
    await CrmService()
        .editDocument(_copyOfCurrentEditDocument, file, _currentEditDocumentId)
        .then((response) async {
      var res = json.decode(response);
      if (res["error"] == false) {
        await fetchDocuments();
      }
      result = res;
    }).catchError((onError) {
      print("editDocument Error >> $onError");
      result = {"status": "error", "message": "Something went wrong"};
    });
    return result;
  }

  deleteDocument(Document file) async {
    Map? result;
    await CrmService().deleteDocument(file.id).then((response) async {
      var res = (json.decode(response.body));
      await fetchDocuments();
      result = res;
    }).catchError((onError) {
      print("deleteDocument Error >> $onError");
      result = {
        "status": "error",
        "message": "deleteDocument : Something went wrong."
      };
    });
    return result;
  }

  cancelCurrentEditDocument() {
    _currentEditDocumentId = null;
    _currentEditDocument = {'title': "", 'teams': [], 'shared_to': []};
  }

  updateCurrentEditDocument(Document editFile) {
    _currentEditDocumentId = editFile.id.toString();
    List sharedToList = [];
    List teams = [];

    editFile.sharedTo!.forEach((sharee) {
      sharedToList.add(sharee.id.toString());
    });

    editFile.teams!.forEach((team) {
      teams.add(team.id);
    });

    _currentEditDocument['title'] = editFile.title;
    _currentEditDocument['document_file'] = editFile.documentFile;
    _currentEditDocument['teams'] = teams;
    _currentEditDocument['shared_to'] = sharedToList;
    _currentEditDocument['status'] = editFile.status;
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

  Document? get currentDocument {
    return _currentDocument;
  }

  set currentDocument(document) {
    _currentDocument = document;
  }

  int? get currentDocumentIndex {
    return _currentDocumentIndex;
  }

  set currentDocumentIndex(index) {
    _currentDocumentIndex = index;
  }

  String? get currentEditDocumentId {
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
