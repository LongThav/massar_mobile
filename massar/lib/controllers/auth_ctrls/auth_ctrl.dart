import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/constants/logger.dart';
import 'dart:convert';

import '../../constants/snack_bar.dart';
import '../../models/auth_model/login_model.dart';
import '../../constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';
import '../../views/dashboards/mains_views.dart/index_views.dart';

class AuthController extends ChangeNotifier {
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoadingRegister = false;
  bool get isLoadingRegister => _isLoadingRegister;

  void setRegisterLoading(bool value) {
    _isLoadingRegister = value;
    notifyListeners();
  }

  LoginModel _loginModel = LoginModel(data: Data(user: User()));
  LoginModel get loginModel => _loginModel;

  final AuthHelper _authHelper = AuthHelper();

  // register account
  Future<bool> registerCtrl(String fullname, String phone, String password,
      String email, BuildContext context) async {
    try {
      final Map<String, dynamic> body = {
        'fullname': fullname,
        'phone': phone,
        'email': email,
        'password': password,
      };
      debugPrint("Body: $body");
      String url = mainUrl + registerendPoint;
      http.Response response = await http.post(Uri.parse(url), body: body);
      debugPrint("Respone Body: ${response.body}");
      if (response.statusCode == 200) {
        _authHelper.writeRegister(response.body);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  //login
  Future<bool> loginCtrl(
      String email, String password, BuildContext context) async {
    try {
      final Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      String url = mainUrl + loginendPoint;
      http.Response response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        _authHelper.writeLogin(response.body);
        _loginModel = await compute(pareLoginJson, response.body);
        _authHelper.writeToken(_loginModel.data.accessToken);
        "Token User login: ${_loginModel.data.accessToken}".log();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (_loginModel.data.user.email == email ||
              _loginModel.data.accessToken == password) {
            snackBar(context, "Login successfully");
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return const IndexView();
            }), (route) => false);
          } else {
            snackBar(context, 'Email or Password incorrect');
          }
        });
        return true;
      } else {
        return false;
      }
    } catch (err) {
      snackBar(context, 'Email or Password incorrect');
      return false;
    } finally {
      notifyListeners();
    }
  }


  Future<bool> forgotPasswordController(String email)async{
    try{
      final Map<String, dynamic> map = {
        'email': email,
      };
      String url = mainUrl + forgotPassword;
      http.Response response = await http.post(Uri.parse(url), body: map);
      debugPrint("Response Body: ${response.body}");
      if(response.statusCode == 200){
        return true;
      }else{
        return false;;
      }
    }catch(e){
      debugPrint("Error: $e");
      return false;
    }finally{
      notifyListeners();
    }
  }

  Future<bool> verifyPinController(String email, String pin)async{
    try{
      String url = mainUrl + verifyPin;
      final Map<String, dynamic> map = {
        'email': email,
        'token': pin
      };
      http.Response response = await http.post(Uri.parse(url), body: map);
      debugPrint("Response Body: ${response.body}");
      if(response.statusCode ==  200){
        return true;
      }else{
        return false;
      }
    }catch(err){
      debugPrint("Error: $err");
      return false;
    }finally{
      notifyListeners();
    }
  }

  Future<bool> resentVerifyPinController(String email)async{
    try{
      final Map<String, dynamic> map = {
        'email': email
      };
      String url = mainUrl + resentPin;
      http.Response response = await http.post(Uri.parse(url), body: map);
      debugPrint("Response Body: ${response.body}");
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(err){
      debugPrint("Error: $err");
      return false;
    }finally{
      notifyListeners();
    }
  }

  Future<bool> setNewPassword(String email ,String password, String passwordConfirm)async{
    try{
      final Map<String, dynamic> map  = {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm
      };
      String url = mainUrl + changePassword;
      http.Response response = await http.post(Uri.parse(url), body: map);
      debugPrint("Response Body: ${response.body}");
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      debugPrint("Error: $e");
      return false;
    }finally{
      notifyListeners();
    }
  }
}

LoginModel pareLoginJson(String jsonString) =>
    LoginModel.fromJson(json.decode(jsonString));
