import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_crm/model/document.dart';
import 'package:flutter_crm/model/profile.dart';
import 'package:flutter_crm/services/crm_services.dart';

// --------------------------DOCUMENT DOWNLOAD IMPORTS----------------
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DocumentBloc {
  List<Document> _activeDocuments = [];
  List<Document> _inActiveDocuments = [];
  List<Document> _documents = [];

  List _statusObjforDropdown = [];
  List<Profile> _usersObjforMultiselect = [];

  fetchDocuments() async {
    await CrmService().getDocuments().then((response) {
      _activeDocuments.clear();
      _inActiveDocuments.clear();
      _documents.clear();

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
        _usersObjforMultiselect.add(user);

        print('fetchDocuments Response >> $res');
      });
    }).catchError((onError) {
      print('fetchDocuments Error >> $onError');
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

  List get statusObjforDropdown {
    return _statusObjforDropdown;
  }

  List get usersObjforMultiselect {
    return _usersObjforMultiselect;
  }
  // --------------------------DOCUMENT DOWNLOAD METHODS----------------

  // Download Directory GET Method
  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  // Download method
  Future<bool> requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  Future<void> downloadFunc(_fileName, String _fileUrl) async {
    final dir = await getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, _fileName);
      await startDownload(savePath, _fileUrl);
    } else {
      // handle the scenario when user declines the permissions
    }
  }

  final Dio _dio = Dio();

  // Start Download Method
  Future<void> startDownload(String _savePath, String _fileUrl) async {
    await Dio()
        .download(
      _fileUrl,
      _savePath,
    )
        .then((response) {
      var res = response;
    });
  }
}

final documentBLoc = DocumentBloc();
