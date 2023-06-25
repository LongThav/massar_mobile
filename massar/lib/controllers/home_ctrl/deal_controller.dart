import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/models/deal_model/deal_model.dart';
import '/constants/logger.dart';
import '../../constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';
import '../../constants/loading_status.dart';

class DealController extends ChangeNotifier {
  DealModel _dealModel = DealModel();
  DealModel get dealModel => _dealModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  void readDeal() async {
    try {
      String url = mainUrl + deal;
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      "ResponeBody: ${response.body}".log();
      if (response.statusCode == 200) {
        _dealModel = await compute(pareJsonDeal, response.body);
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

DealModel pareJsonDeal(String str) => DealModel.fromJson(json.decode(str));
