import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/logger.dart';
import '../../utils/constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';
import '/models/beauty_model.dart/beauty_model.dart';
import '../../utils/constants/loading_status.dart';

class BeautyController extends ChangeNotifier {
  BeautyModel _beautyModel = BeautyModel();
  BeautyModel get beautyModel => _beautyModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  void readBeauty() async {
    try {
      String url = mainUrl + beauty;
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      "ResponeBody: ${response.body}".log();
      if (response.statusCode == 200) {
        _beautyModel = await compute(pareJsonBeauty, response.body);
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

BeautyModel pareJsonBeauty(String str) =>
    BeautyModel.fromJson(json.decode(str));
