import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'checkout_cart_view.dart';
import '../../../../utils/constants/snack_bar.dart';
import '../../../../utils/constants/url_base.dart';
import '../../../../utils/constants/color.dart';
import '../../../../utils/constants/loading_status.dart';
import '/controllers/home_ctrl/electronic_ctrl.dart';
import '/models/cart_model.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _select = false;
  bool _selectAll = false;
  bool selectIndex = false;
  double totalPayment = 0;

  double totalPrice = 0;

  List<int> totalItem = [];
  List<CartModel> product = [];

  CartModel _cartModelPro(
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ElectronicCtrl>().setLoading();
      context.read<ElectronicCtrl>().readCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Your Cart"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    List<CartModel> cartModel = context.watch<ElectronicCtrl>().cartModel;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectAll = !_selectAll;
                  });
                },
                child: Checkbox(
                    value: _select,
                    activeColor: const Color(0XFF06AB8D),
                    onChanged: (newBool) {
                      setState(() {
                        _selectAll = _select = newBool!;
                        if (_selectAll == true) {
                          totalItem.add(cartModel.length);
                          debugPrint("Add all: $totalItem");
                        } else {
                          totalItem.clear();
                          debugPrint("Clear all: $totalItem");
                        }
                      });
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Select All Item",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.66,
      child: _buildItemCart(),
    );
  }

  Widget _buildItemCart() {
    LoadingStatus loadingStatus = context.watch<ElectronicCtrl>().loadingStatus;
    if (loadingStatus == LoadingStatus.none ||
        loadingStatus == LoadingStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == LoadingStatus.error) {
      return const Center(
        child: Text("Error"),
      );
    } else {
      return _buildList();
    }
  }

  Widget _buildList() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<CartModel> cartModel = context.watch<ElectronicCtrl>().cartModel;

    if (cartModel.isEmpty) {
      return Center(
        child: Text(
          "No product in Cart",
          style: TextStyle(fontSize: 25, color: Colors.grey[700]),
        ),
      );
    }
    cartModel;
    return ListView.builder(
        itemCount: cartModel.length,
        itemBuilder: (context, index) {
          var data = cartModel[index];
          var price = double.parse(data.cartPrice);
          // debugPrint("Price: ${price * data.total}");
          double total = cartModel
              .map<double>((item) => price * item.total)
              .reduce((value1, value2) => value1 + value2);
          totalPrice = total;
          // debugPrint("total price: $totalPrice");
          return GestureDetector(
            onLongPress: () {
              setState(() {
                selectIndex = data.isSelect = !data.isSelect;
                if (selectIndex == true) {
                  totalItem.add(index);
                  debugPrint("add: $totalItem");
                  context.read<ElectronicCtrl>().addTotalPrize(total);
                  product.add(_cartModelPro(
                      data.id,
                      data.cartName,
                      data.cartSellerName,
                      data.cartPrice,
                      data.cartRate,
                      data.cartImage,
                      data.cartDiscount));
                } else {
                  totalItem.removeLast();
                  product.removeLast();
                  double cartpirc = double.parse(data.cartPrice);
                  double cart = total - cartpirc;
                  context.read<ElectronicCtrl>().addTotalPrize(cart);
                  debugPrint("After remove: $totalItem");
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: width,
              height: height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      data.isSelect == false
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.all(4),
                            )
                          : Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(
                                left: 20,
                              ),
                              decoration: const BoxDecoration(
                                  color: mainColor, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  LineIcons.check,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      _selectAll == false
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.all(4),
                            )
                          : Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(
                                left: 20,
                              ),
                              decoration: const BoxDecoration(
                                  color: mainColor, shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  LineIcons.check,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Container(
                    width: width * 0.2,
                    height: height * 0.1,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(hostImg + data.cartImage),
                            fit: BoxFit.fill)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 8.0),
                          child: Text(
                            data.cartName,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '\$${price * data.total}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(right: width * 0.15),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (data.isSelect == true) {
                                      if (data.total > 1) {
                                        data.total--;
                                        // data.total -= data.total + 1;
                                      } else {
                                        snackBar(context,
                                            "Product can't be not empty");
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Center(
                                      child: Text(
                                    "-",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  data.total.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (data.isSelect == true) {
                                    setState(() {
                                      debugPrint("befor up: ${data.total}");
                                      data.total = data.total + 1;
                                      debugPrint("Up total: ${data.total}");
                                    });
                                    context
                                        .read<ElectronicCtrl>()
                                        .addTotalPrize(total);
                                  }
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Center(
                                      child: Text(
                                    "+",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                        onPressed: () {
                          context.read<ElectronicCtrl>().deleteProCart(data.id);
                          cartModel.removeAt(index);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.grey[400],
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBottom() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    double payment = context.read<ElectronicCtrl>().totalPrice;
    return Container(
      width: width,
      height: height * 0.11,
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(width: 2, color: mainColor)),
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: const Text(
                "Total Payment",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$$payment",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                GestureDetector(
                  onTap: () {
                    if (selectIndex == true || _selectAll == true) {
                      debugPrint("Buy item");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckOutCartElectronicView(cartModel: product);
                      }));
                    } else {
                      snackBar(context, "Please select item");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFB039),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Buy (${totalItem.length} Item)",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
