import 'package:flutter/material.dart';
import 'package:project/controllers/home_ctrl/fashion_ctrl.dart';
import 'package:project/views/dashboards/home_views/cart_list_view.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/snack_bar.dart';
import '/models/cart_model.dart';
import '/widgets/common_view_index_item.dart';
import '../../../utils/constants/logger.dart';
import '../../../utils/constants/url_base.dart';
import '../../../controllers/home_ctrl/electronic_ctrl.dart';

class ViewDetailItemElectronic extends StatefulWidget {
  final int id;
  final String name;
  final String sellerName;
  final String price;
  final String image;
  final String discount;
  final String? rate;
  const ViewDetailItemElectronic(
      {super.key,
      required this.name,
      required this.sellerName,
      required this.price,
      required this.image,
      required this.discount,
      this.rate,
      required this.id});

  @override
  State<ViewDetailItemElectronic> createState() =>
      _ViewDetailItemElectronicState();
}

class _ViewDetailItemElectronicState extends State<ViewDetailItemElectronic> {
  final TextEditingController _commentCtrl = TextEditingController();

  int total = 0;

  final List<CartModel> _cartModel = [];

  CartModel _storeItem(
      String id,
      String cartName,
      String cartSellerName,
      String cartPrice,
      String cartRate,
      String cartImage,
      String cartDiscount) {
    var pro = CartModel(
        id: id,
        cartName: cartName,
        cartSellerName: cartSellerName,
        cartPrice: cartPrice,
        cartDiscount: cartDiscount,
        cartRate: cartRate,
        cartImage: cartImage);
    return pro;
  }

  @override
  void initState() {
    _cartModel.add(_storeItem(
        widget.id.toString(),
        widget.name,
        widget.sellerName,
        widget.price,
        widget.rate ?? "0",
        widget.image,
        widget.discount));
    '_cart Item first: $_cartModel'.log();
    super.initState();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int value = context.watch<ElectronicCtrl>().totalPro;
    // "value: $value".log();
    int price = int.parse(widget.price);
    // "${price * value}".log();
    total = price * value;
    "Total: $total".log();
    return ViewDetailItemByFilter(
      title: 'Electronic',
      name: widget.name,
      sellerName: widget.sellerName,
      price: widget.price,
      image: hostImg + widget.image,
      discount: widget.discount,
      id: widget.id,
      rate: widget.rate,
      increment: () {
        context.read<ElectronicCtrl>().setIncrementPro();
      },
      decrement: () {
        if (value <= 1) {
          'After -: $_cartModel'.log();
          "Product can't empty".log();
          snackBar(context, "Product total can't empty");
        } else {
          context.read<ElectronicCtrl>().setDecrementPro();
        }
      },
      totalItem: value,
      clearList: () {
        Navigator.pop(context);
        if (!mounted) return;
        _cartModel.clear();
        context.read<ElectronicCtrl>().clearTotalPro();
        context.read<ElectronicCtrl>().setLoading();
        context.read<ElectronicCtrl>().readElectronic();
      },
      commment: _commentCtrl,
      submitComment: () {},
      gotoCart: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return CartListViewElectronic(
        //       cartModel: _cartModel,
        //       totalPrice: total,
        //       id: widget.id,
        //       name: widget.name,
        //       sellerName: widget.sellerName,
        //       price: widget.price,
        //       image: widget.image,
        //       discount: widget.discount);
        // }));
        CartModel cartModel = CartModel(
            id: widget.id.toString(),
            cartName: widget.name,
            cartSellerName: widget.sellerName,
            cartPrice: widget.price,
            cartDiscount: widget.discount,
            cartRate: widget.rate ?? "0",
            cartImage: widget.image);
        context.read<ElectronicCtrl>().addProuctCart(cartModel, context);
      },
    );
  }
}

class ViewDetailItemFahsion extends StatefulWidget {
  final int id;
  final String name;
  final String sellerName;
  final String price;
  final String image;
  final String discount;
  final String? rate;
  const ViewDetailItemFahsion(
      {super.key,
      required this.name,
      required this.sellerName,
      required this.price,
      required this.image,
      required this.discount,
      this.rate,
      required this.id});

  @override
  State<ViewDetailItemFahsion> createState() => _ViewDetailItemFahsionState();
}

class _ViewDetailItemFahsionState extends State<ViewDetailItemFahsion> {
  final TextEditingController _commentCtrl = TextEditingController();

  int total = 0;

  final List<CartModel> _cartModel = [];

  CartModel _storeItem(
      String id,
      String cartName,
      String cartSellerName,
      String cartPrice,
      String cartRate,
      String cartImage,
      String cartDiscount) {
    var pro = CartModel(
        id: id,
        cartName: cartName,
        cartSellerName: cartSellerName,
        cartPrice: cartPrice,
        cartDiscount: cartDiscount,
        cartRate: cartRate,
        cartImage: cartImage);
    return pro;
  }

  @override
  void initState() {
    _cartModel.add(_storeItem(
        widget.id.toString(),
        widget.name,
        widget.sellerName,
        widget.price,
        widget.rate ?? "0",
        widget.image,
        widget.discount));
    '_cart Item first: $_cartModel'.log();
    super.initState();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int value = context.watch<FashionController>().totalPro;
    // "value: $value".log();
    int price = int.parse(widget.price);
    // "${price * value}".log();
    total = price * value;
    "Total: $total".log();
    return ViewDetailItemByFilter(
      title: 'Fashion',
      name: widget.name,
      sellerName: widget.sellerName,
      price: widget.price,
      image: hostImg + widget.image,
      discount: widget.discount,
      id: widget.id,
      rate: widget.rate,
      increment: () {
        context.read<FashionController>().setIncrementPro();
      },
      decrement: () {
        if (value <= 1) {
          'After -: $_cartModel'.log();
          "Product can't empty".log();
          snackBar(context, "Product total can't empty");
        } else {
          context.read<ElectronicCtrl>().setDecrementPro();
        }
      },
      totalItem: value,
      clearList: () {
        Navigator.pop(context);
        if (!mounted) return;
        _cartModel.clear();
        context.read<FashionController>().clearTotalPro();
        context.read<FashionController>().setLoading();
        context.read<FashionController>().readFashion();
      },
      commment: _commentCtrl,
      submitComment: () {},
      gotoCart: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return CartListViewFashion(
        //       cartModel: _cartModel,
        //       totalPrice: total,
        //       id: widget.id,
        //       name: widget.name,
        //       sellerName: widget.sellerName,
        //       price: widget.price,
        //       image: widget.image,
        //       discount: widget.discount);
        // }));
        // int price = int.parse(widget.price);
        CartModel cartModel = CartModel(
            id: widget.id.toString(),
            cartName: widget.name,
            cartSellerName: widget.sellerName,
            cartPrice: widget.price,
            cartDiscount: widget.discount,
            cartRate: widget.rate ?? "0",
            cartImage: widget.image);
        context.read<ElectronicCtrl>().addProuctCart(cartModel, context);
      },
    );
  }
}
