import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/models/f_and_b.dart/f_and_b_model.dart';
import '/constants/loading_status.dart';
import '/constants/logger.dart';
import '../../constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';

class FANDBController extends ChangeNotifier {
  FANBModel _fandbModel = FANBModel();
  FANBModel get fandbModel => _fandbModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  void readFandB() async {
    try {
      String url = mainUrl + fandd;
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      "ResponeBody: ${response.body}".log();
      if (response.statusCode == 200) {
        _fandbModel = await compute(pareJsonFandB, response.body);
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

FANBModel pareJsonFandB(String str) => FANBModel.fromJson(json.decode(str));
