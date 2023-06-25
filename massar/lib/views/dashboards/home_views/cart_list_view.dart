// import 'package:flutter/material.dart';
// import 'package:project/controllers/home_ctrl/fashion_ctrl.dart';
// import 'package:provider/provider.dart';

// import '/constants/logger.dart';
// import '/widgets/common_cart_list_view.dart';
// import '../../../controllers/home_ctrl/electronic_ctrl.dart';
// import '/constants/snack_bar.dart';
// import '/models/cart_model.dart';
// import 'shopping_carts/checkout_cart_view.dart';

// class CartListViewElectronic extends StatefulWidget {
//   final List<CartModel> cartModel;
//   final int totalPrice;
//   final int id;
//   final String name;
//   final String sellerName;
//   final String price;
//   final String image;
//   final String discount;
//   final String? rate;
//   const CartListViewElectronic(
//       {super.key,
//       required this.cartModel,
//       required this.totalPrice,
//       required this.id,
//       required this.name,
//       required this.sellerName,
//       required this.price,
//       required this.image,
//       required this.discount,
//       this.rate});

//   @override
//   State<CartListViewElectronic> createState() => _CartListViewElectronicState();
// }

// class _CartListViewElectronicState extends State<CartListViewElectronic> {
//   int price = 0;

//   @override
//   Widget build(BuildContext context) {
//     int value = context.watch<ElectronicCtrl>().totalPro;
//     "Value: $value".log();
//     price = int.parse(widget.price);
//     return CommonCartListView(
//         cartModel: widget.cartModel,
//         totalPrice: price * value,
//         id: widget.id,
//         name: widget.name,
//         sellerName: widget.sellerName,
//         price: '${price * value}\$',
//         image: widget.image,
//         discount: widget.discount,
//         decrement: () {
//           setState(() {
//             "Value: $value".log();
//             if (value > 1) {
//               context.read<ElectronicCtrl>().setDecrementPro();
//             } else if (value == 1) {
//               "can't dok".log();
//               snackBar(context, "Product can't be not empty");
//             } else if (value < 1) {
//               snackBar(context, "Product can't be not empty");
//             } else {
//               "can't dok".log();
//               snackBar(context, "Product can't be not empty");
//             }
//           });
//         },
//         increment: () {
//           setState(() {
//             context.read<ElectronicCtrl>().setIncrementPro();
//           });
//         },
//         total: value, 
//         buy: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context){
//             return const CheckOutCartElectronicView();
//           }));
//         },);
//   }
// }




// class CartListViewFashion extends StatefulWidget {
//   final List<CartModel> cartModel;
//   final int totalPrice;
//   final int id;
//   final String name;
//   final String sellerName;
//   final String price;
//   final String image;
//   final String discount;
//   final String? rate;
//   const CartListViewFashion(
//       {super.key,
//       required this.cartModel,
//       required this.totalPrice,
//       required this.id,
//       required this.name,
//       required this.sellerName,
//       required this.price,
//       required this.image,
//       required this.discount,
//       this.rate});

//   @override
//   State<CartListViewFashion> createState() => _CartListViewFashionState();
// }

// class _CartListViewFashionState extends State<CartListViewFashion> {
//   int price = 0;

//   @override
//   Widget build(BuildContext context) {
//     int value = context.watch<FashionController>().totalPro;
//     "Value: $value".log();
//     price = int.parse(widget.price);
//     return CommonCartListView(
//         cartModel: widget.cartModel,
//         totalPrice: price * value,
//         id: widget.id,
//         name: widget.name,
//         sellerName: widget.sellerName,
//         price: '${price * value}\$',
//         image: widget.image,
//         discount: widget.discount,
//         decrement: () {
//           setState(() {
//             "Value: $value".log();
//             if (value > 1) {
//               context.read<FashionController>().setDecrementPro();
//             } else if (value == 1) {
//               "can't dok".log();
//               snackBar(context, "Product can't be not empty");
//             } else if (value < 1) {
//               snackBar(context, "Product can't be not empty");
//             } else {
//               "can't dok".log();
//               snackBar(context, "Product can't be not empty");
//             }
//           });
//         },
//         increment: () {
//           setState(() {
//             context.read<FashionController>().setIncrementPro();
//           });
//         },
//         total: value, buy: () {  },);
//   }
// }
