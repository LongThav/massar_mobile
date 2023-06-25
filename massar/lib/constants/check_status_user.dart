import 'package:flutter/material.dart';
import 'package:project/constants/logger.dart';

import '../db_helper_local/auth_db_helper/auth_db_local.dart';
import '../views/auths/login_view.dart';
import '../views/dashboards/mains_views.dart/index_views.dart';

class CheckStatusUser {
  void checkStatus(BuildContext context) async {
    AuthHelper authHelper = AuthHelper();
    var userInfo = await authHelper.readLocalLogin();
    debugPrint("UserInfor: $userInfo");

    var token = await authHelper.readToken();
    "Token user: $token".log();
    if (userInfo == authHelper.noKeyLogin) {
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const LoginView();
        }), (route) => false);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const IndexView();
        }), (route) => false);
      });
    }
  }
}
