import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project/models/auth_model/user_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/logger.dart';
import '../../utils/constants/url_base.dart';
import '../../utils/constants/loading_status.dart';
import '/db_helper_local/auth_db_helper/auth_db_local.dart';
import '/models/auth_model/login_model.dart';

class ProfileController extends ChangeNotifier {
  LoginModel _loginModel = LoginModel(data: Data(user: User()));
  LoginModel get loginModel => _loginModel;
  AllUserModel _allUserModel = AllUserModel();
  AllUserModel get allUserModel => _allUserModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _loadingStatus = LoadingStatus.loading;
      context.read<ProfileController>().readLocalProfile();
    });
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  Future<void> readLocalProfile() async {
    var cache = await _authHelper.readLocalLogin();
    if (cache == _authHelper.noKeyLogin) {
      _loadingStatus = LoadingStatus.error;
    } else {
      _loginModel = await compute(_pareJsonLogin, cache);
      _loadingStatus = LoadingStatus.done;
    }
    notifyListeners();
  }

  String _fileName = '';
  String get fileName => _fileName;

  List<int> _fileBytes = [];
  List<int> get fileBytes => _fileBytes;

  String _fileBase64 = '';
  String get fileBase64 => _fileBase64;

  File? _localFile;
  File? get localFile => _localFile;

  final _serviceName = 'Location Service';

  void readFilebase64(String value){
    _fileBase64 = value;
    notifyListeners();
  }

  Future<void> getFileBase64String(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'png', 'jpg', 'pdf'],
      );
      if (result == null) return;

      _fileName = result.files.first.name;

      final filePath = result.files.first.path.toString();
      final int fileSize = result.files.first.size;
      final String fileName = result.files.first.name;
      final String fileExtension =
          fileName.substring(fileName.lastIndexOf('.') + 1);
      'fileExtension: $fileExtension'.log();

      var typeFile = File(filePath);
      _localFile = typeFile;

      //handle the image file upload
      if (fileExtension != 'pdf') {
        final double totalSize = fileSize / 1000;
        if (totalSize / 1000 > 1) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        } else {
          final List<int> imageBytes = typeFile.readAsBytesSync();
          _fileBytes = imageBytes;
          _fileBase64 =
              "data:image/$fileExtension;base64,${base64Encode(imageBytes)}";
          debugPrint("Base 64: $_fileBase64");
          Future.delayed(const Duration(milliseconds: 600), () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File has been added...'),
              ),
            );
          });
        }
      } else {
        var totalSize = fileSize / 1000;
        if (totalSize / 1000 > 1) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        }
        final List<int> pdfBytes = typeFile.readAsBytesSync();
        _fileBytes = pdfBytes;
        _fileBase64 = "data:@file/pdf;base64,${base64Encode(pdfBytes)}";
      }
    } catch (err) {
      '$_serviceName getPatenBase64String exception: $err'.log();
    } finally {
      '$_serviceName getPatenBase64String finally'.log();
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    try {
      var token = await _authHelper.readToken();
      String url = mainUrl + logoutendPoint;
      http.Response response = await http.post(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      "Respone Body: ${response.body}".log();
      if (response.statusCode == 200) {
        _authHelper.deleteAll();
        return true;
      } else {
        return false;
      }
    } catch (err) {
      'Respone error: $err'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  bool _isLoadding = false;
  bool get isLoading => _isLoadding;

  void setUpdateLoading(bool value){
    _isLoadding = value;
    notifyListeners();
  }

  Future<bool> updateProfileCtrl(int id,
      String image,String fullname, String email, String phone, String address) async {
    try {
      var token = await _authHelper.readToken();
      final Map<String, dynamic> map = {
        'id': id,
        'image': image,
        'fullname': fullname,
        'email': email,
        'phone': phone,
        'address': address,
      };
      "Map: $map".log();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      var body = jsonEncode(map);
      String url = mainUrl + updateProfile;
      "Url: $url".log();
      http.Response response =
          await http.put(Uri.parse(url), body: body, headers: header);
      "Response Body: ${response.body}".log();
      if (response.statusCode == 200) {
        return true;
      } else {
        "Other error".log();
        return false;
      }
    } catch (err) {
      "Respone err: $err".log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> readAllUser()async{
    try{
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      String url = mainUrl + allUser;
      http.Response response = await http.get(Uri.parse(url), headers: header);
      if(response.statusCode == 200){
        _allUserModel = await compute(__parJsonAllUser, response.body);
        _loadingStatus = LoadingStatus.done;
      }
    }catch(err){
      debugPrint("Error: $err");
      _loadingStatus = LoadingStatus.error;
    }finally{
      notifyListeners();
    }
  }
}

LoginModel _pareJsonLogin(String jsonString) {
  return LoginModel.fromJson(json.decode(jsonString));
}

AllUserModel __parJsonAllUser(String str) => AllUserModel.fromJson(json.decode(str));