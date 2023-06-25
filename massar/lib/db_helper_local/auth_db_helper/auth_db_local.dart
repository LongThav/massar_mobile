import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthHelper {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();

  //local for register

  final String keyRegister = "Key";
  final String noKey = "noKey";

  void writeRegister(String value) {
    _flutterSecureStorage.write(key: keyRegister, value: value);
  }

  Future<String> readLocalRegister() async {
    String? cache = await _flutterSecureStorage.read(key: keyRegister);
    return cache ?? noKey;
  }

  //local for login

  final String keyLogin = "key";
  final String noKeyLogin = "noKey";

  void writeLogin(String value) {
    _flutterSecureStorage.write(key: keyLogin, value: value);
  }

  Future<String> readLocalLogin() async {
    String? cache = await _flutterSecureStorage.read(key: keyLogin);
    return cache ?? noKeyLogin;
  }

  //token handle

  final String token = "token";
  final String noToken = "noToken";

  void writeToken(String value){
    _flutterSecureStorage.write(key: token, value: value);
  }

  Future<String> readToken()async{
    String? cache = await _flutterSecureStorage.read(key: token);
    return cache ?? noToken;
  }

  void deleteAll(){
    _flutterSecureStorage.deleteAll();
  }
}
