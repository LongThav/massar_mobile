import 'package:flutter/material.dart';
import 'package:project/utils/constants/url_base.dart';
import 'package:project/controllers/home_ctrl/home_ctrl.dart';
import 'package:project/models/cart_model.dart';
import 'package:project/utils/ulti_push.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/color.dart';
import '../../../../controllers/home_ctrl/electronic_ctrl.dart';
import 'total_payment_view.dart';

class CheckOutCartElectronicView extends StatefulWidget {
  final List<CartModel> cartModel;
  final double price;
  const CheckOutCartElectronicView({super.key, required this.cartModel, required this.price});

  @override
  State<CheckOutCartElectronicView> createState() =>
      _CheckOutCartElectronicViewState();
}

class _CheckOutCartElectronicViewState
    extends State<CheckOutCartElectronicView> {
  final TextEditingController _upponCtrl = TextEditingController();
  @override
  void dispose() {
    _upponCtrl.dispose();
    super.dispose();
  }

  List<dynamic> sumeryOrder = [
    {
      "title": "Delivery Fee",
      "price": "\$4,00",
    },
    {"title": "Subtotal", "price": "\$1,468.20"},
    {"title": "Tax", "price": "\$1,00"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        centerTitle: true,
        title: const Text("CheckOut"),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildTotalPayment(),
    );
  }

  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String address = context.read<HomeController>().address;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.025),
            child: const Text(
              "Shiping Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$address.'),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Change Address.",
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Summery Item",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildProSumery(),
          SizedBox(
            height: height * 0.03,
          ),
          _buildCoupon(),
          SizedBox(
            height: height * 0.03,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Summery Order",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSummeryOrder(),
        ],
      ),
    );
  }

  Widget _buildProSumery() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: List.generate(widget.cartModel.length, (index) {
          double price = double.parse(widget.cartModel[index].cartPrice);
          return Container(
            width: width,
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: width * 0.2,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.5),
                          image: DecorationImage(
                              image: NetworkImage(
                                  hostImg + widget.cartModel[index].cartImage),
                              fit: BoxFit.fill)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
                          child: Text(
                            widget.cartModel[index].cartName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15, bottom: 15),
                          child: Text(
                            "\$$price",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  "Quantity 1",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300]),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCoupon() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: height * 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: width * 0.55,
            child: TextField(
              controller: _upponCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter coupon code',
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 18,
              bottom: 18,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1, color: mainColor),
                color: mainColor.withOpacity(0.3)),
            child: Center(
              child: Text(
                "Use coupon".toUpperCase(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPayment() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // double payment = context.read<ElectronicCtrl>().totalPrice;
    return Container(
      width: width,
      height: height * 0.11,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
                  "${widget.price}\$",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                GestureDetector(
                  onTap: () {
                    pushPage(context,  TotalPaymentView(price: widget.price,));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFB039),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
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

  Widget _buildSummeryOrder() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: List.generate(sumeryOrder.length, (index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(sumeryOrder[index]['title'] + ":",
                style: TextStyle(
                  fontSize: 15, color: Colors.grey[600]
                ),
                ),
              ),
              Text(sumeryOrder[index]['price'])
            ],
          );
        }),
      ),
    );
  }
}

