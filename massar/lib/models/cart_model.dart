import 'package:equatable/equatable.dart';

class CartModel extends Equatable{
  String id;
  String cartName;
  String cartSellerName;
  String cartPrice;
  String cartRate;
  String cartImage;
  String cartDiscount;
  bool isSelect;
  int total;

  CartModel({
    this.isSelect = false,
    this.total = 1,
    required this.id,
    required this.cartName,
    required this.cartSellerName,
    required this.cartPrice,
    required this.cartDiscount,
    required this.cartRate,
    required this.cartImage
  });
  
  @override
  List<Object?> get props => [
    id, cartName, cartSellerName, cartPrice, cartDiscount, cartRate, cartImage
  ];


}