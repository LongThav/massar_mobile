import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/constants/loading_status.dart';
import '/constants/logger.dart';
import '/models/fashion_model/fashion_model.dart';
import '../../constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';

class FashionController extends ChangeNotifier {
  FashionModel _fashionModel = FashionModel();
  FashionModel get fashionModel => _fashionModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  void readFashion() async {
    try {
      String url = mainUrl + fashion;
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      "ResponeBody: ${response.body}".log();
      if (response.statusCode == 200) {
        _fashionModel = await compute(pareJsonFashion, response.body);
        _loadingStatus = LoadingStatus.done;
      }
    } catch (err) {
      'Error status: $err'.log();
      _loadingStatus = LoadingStatus.error;
    } finally {
      notifyListeners();
    }
  }

  int _totalPro = 1;
  int get totalPro => _totalPro;

  void setIncrementPro() {
    _totalPro++;
    notifyListeners();
  }

  void setDecrementPro() {
    _totalPro--;
    notifyListeners();
  }

  void clearTotalPro() {
    _totalPro = 1;
    notifyListeners();
  }
}

FashionModel pareJsonFashion(String str) =>
    FashionModel.fromJson(json.decode(str));
