import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../utils/constants/snack_bar.dart';
import '/db_helper_local/cache_local_storages/add_to_cart_db.dart';
import '/models/cart_model.dart';
import '../../utils/constants/logger.dart';
import '../../utils/constants/url_base.dart';
import '../../db_helper_local/auth_db_helper/auth_db_local.dart';
import '../../utils/constants/loading_status.dart';
import '/models/electronic_model/electronic_model.dart';

class ElectronicCtrl extends ChangeNotifier {
  ElectronicModel _electronicModel = ElectronicModel();
  ElectronicModel get electronicModel => _electronicModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();

  void readElectronic() async {
    try {
      String url = mainUrl + electronic;
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      "ResponeBody: ${response.body}".log();
      if (response.statusCode == 200) {
        _electronicModel = await compute(pareJsonElectronic, response.body);
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

  List<CartModel> _cartModel = [];
  List<CartModel> get cartModel => _cartModel;

  void addProuctCart(CartModel cartModel, BuildContext context) async {
    try {
      final newProduct = CartModel(
          id: const Uuid().v1(),
          cartName: cartModel.cartName,
          cartSellerName: cartModel.cartSellerName,
          cartPrice: cartModel.cartPrice,
          cartDiscount: cartModel.cartDiscount,
          cartRate: cartModel.cartRate,
          cartImage: cartModel.cartImage);
      _cartModel.add(newProduct);
      'CartModel data: $_cartModel'.log();
      await CartDB.addItemCart(CartDB.product, {
        'id': newProduct.id,
        'cartName': newProduct.cartName,
        'cartSellerName': newProduct.cartSellerName,
        'cartPrice': newProduct.cartPrice,
        'cartRate': newProduct.cartRate,
        'cartImage': newProduct.cartImage,
        'cartDiscount': newProduct.cartDiscount,
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        snackBar(context, 'Add to cart succesfully');
      });
    } catch (err) {
      'Err: $err'.log();
      debugPrint("Error respone: $err");
    } finally {
      notifyListeners();
    }
  }

  void readCart() async {
    try {
      final prouctList = await CartDB.readItemCart();
      _cartModel = prouctList
          .map((pro) => CartModel(
              id: pro['id'],
              cartName: pro['cartName'],
              cartSellerName: pro['cartSellerName'],
              cartPrice: pro['cartPrice'],
              cartDiscount: pro['cartDiscount'],
              cartRate: pro['cartRate'],
              cartImage: pro['cartImage']))
          .toList();
      'product List: $prouctList'.log();
      _loadingStatus = LoadingStatus.done;
    } catch (err) {
      _loadingStatus = LoadingStatus.error;
    } finally {
      notifyListeners();
    }
  }

  int? _statusCart;
  int? get statusCart => _statusCart;
  void checkStatusCart() {
    _statusCart = _cartModel.length;
    debugPrint("Status cart: $_statusCart");
    notifyListeners();
  }

  void updateProuctCart(
      id,
      String cartName,
      String cartSellerName,
      String cartPrice,
      String cartRate,
      String cartImage,
      String cartDiscount) async {
    try {
      final db = await CartDB.database();
      await db.update(
          CartDB.product,
          {
            'cartName': cartName,
            'cartSellerName': cartSellerName,
            'cartPrice': cartPrice,
            'cartRate': cartRate,
            'cartImage': cartImage,
            'cartDiscount': cartDiscount,
          },
          where: "id = ?",
          whereArgs: [id]);
    } catch (err) {
      "Update error: $err".log();
    } finally {
      notifyListeners();
    }
  }

  void deleteProCart(pickId) async {
    await CartDB.deleteById(CartDB.product, 'id', pickId);
    'Delete item'.log();
    notifyListeners();
  }

  Future deleteTable() async {
    var table = await CartDB.deleteTable(CartDB.product);
    debugPrint("delet table: $table");
    notifyListeners();
  }

  int _itemCart = 1;
  int get itemCart => _itemCart;

  void setIncreItemCart() {
    _itemCart++;
    notifyListeners();
  }

  void setDecriItemCart() {
    _itemCart--;
    notifyListeners();
  }

  double _totalPayment = 0;
  double get totalPayment => _totalPayment;

  int _qt = 0;
  int get qt => _qt;

  void addTotalPayment(double value) {
    _totalPayment = value;
    notifyListeners();
  }

  void readTotlPayment() {
    _totalPayment;
    notifyListeners();
  }

  void addQuantity(int id) {
    final index = _cartModel.indexWhere((element) {
      int idEle = int.parse(element.id);
      return idEle == id;
    });
    _qt = _cartModel[index].total = _cartModel[index].total + 1;
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = _cartModel.indexWhere((element) {
      int idEle = int.parse(element.id);
      debugPrint("Id: $id");
      return idEle == id;
    });
    final currentQuantity = _cartModel[index].total;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      _cartModel[index].total = currentQuantity - 1;
    }
    notifyListeners();
  }

  final int _quantity = 1;
  int get quauntity => _quantity;

  int getQuantity(int quantity) {
    return _quantity;
  }

  double _payment = 0;
  double get payment => _payment;

  void addPayment(double value) {
    _payment = value;
    debugPrint("Payment: $_payment");
    notifyListeners();
  }

  void getpayment() {
    _payment;
    notifyListeners();
  }

  List<CartModel> cart = [];
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  void addTotalPrize(double value){
    _totalPrice = value;
    debugPrint("total payment: $_totalPrice");
    notifyListeners();
  }

  void getPayment(double price, int total){
    cart.map<double>((item)=> price * total)
    .reduce((value, element) => value + element);
    notifyListeners();
  }

  // double price = 0;
  // void addPrice(value){
  //   price = value;
  //   notifyListeners();
  // }
  

  
}

ElectronicModel pareJsonElectronic(String str) =>
    ElectronicModel.fromJson(json.decode(str));
