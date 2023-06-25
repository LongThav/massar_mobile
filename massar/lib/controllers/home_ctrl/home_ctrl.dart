import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';


import 'package:http/http.dart' as http;
import 'package:project/constants/logger.dart';
import 'package:project/constants/url_base.dart';
import 'package:project/db_helper_local/auth_db_helper/auth_db_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  Future<bool> searchCtrl(String value) async {
    try {
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final Map<String, dynamic> map = {
        'search': value,
      };
      final body = jsonEncode(map);
      String url = "$mainUrl/$value";
      http.Response response =
          await http.post(Uri.parse(url), headers: header, body: body);
      'Response Body: ${response.body}'.log();
      if (response.statusCode == 200) {
        return true;
      } else {
        'Other error'.log();
        return false;
      }
    } catch (err) {
      'Respone error: $err'.log();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Location location = Location();

  String _address = '';
  String get address => _address;

  void addAddress(String value){
    _address = value;
    // debugPrint("Address in state Management: $_address");
    notifyListeners();
  }

  final double _lat = 0;
  double? get lat => _lat;

  final double _long = 0;
  double? get long => _long;

  // void fetchLocation(BuildContext context) async {
  //   bool serviceEnabled;
  //   PermissionStatus permisssionGranted;
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }

  //   permisssionGranted = await location.hasPermission();
  //   if (permisssionGranted == PermissionStatus.denied) {
  //     permisssionGranted = await location.requestPermission();
  //     if (permisssionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _currentPosition = await location.getLocation();
  //   location.onLocationChanged.listen((LocationData currentLocation) {
  //     setState(() {
  //       _currentPosition = currentLocation;
  //       _lat = _currentPosition.latitude;
  //       getAddress(_currentPosition.latitude, _currentPosition.longitude)
  //           .then((value) {
  //         debugPrint("Long: ${_currentPosition.longitude}");
  //         debugPrint("lat: ${_currentPosition.latitude}");

  //         setState(() {
  //           _address = value.first.addressLine;
  //           debugPrint("Address now: $_address");
  //         });
  //       });
  //     });
  //   });
  // }

  Future<List<Address>> getAddress(double? lat, double? lang) async {
    final coordinates = Coordinates(lat, lang);
    List<Address> address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return address;
  }

  bool _isSelect = false;
  bool get isSelect => _isSelect;

  void setSelected(bool value){
    _isSelect = value;
    notifyListeners();
  } 

  late SharedPreferences sharedPreferences;
  
  final List<int> _statusMsg = [];
  List<int> get statusMsg => _statusMsg;
  
  void statusChat(value){
    _statusMsg.add(value);
    notifyListeners();
  }

  void clearStatus(){
    _statusMsg.clear();
    notifyListeners();
  }
}
