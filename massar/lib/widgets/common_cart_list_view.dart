import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../constants/url_base.dart';

class CommonCartListView extends StatefulWidget {
  final List cartModel;
  final int totalPrice;
  final int id;
  final String name;
  final String sellerName;
  final String price;
  final String image;
  final String discount;
  final String? rate;
  final VoidCallback increment;
  final VoidCallback decrement;
  final VoidCallback buy;
  final int total;
  const CommonCartListView(
      {super.key,
      required this.cartModel,
      required this.totalPrice,
      required this.id,
      required this.name,
      required this.sellerName,
      required this.price,
      required this.image,
      required this.discount,
      this.rate, required this.increment, required this.decrement, required this.total, required this.buy});

  @override
  State<CommonCartListView> createState() => _CommonCartListViewState();
}

class _CommonCartListViewState extends State<CommonCartListView> {
  int total = 0;
  int price = 0;
  int totalPayment = 0;
  int valueItem = 0;

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
        title: const Text("Your Cart"),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        width: width,
        height: height * 0.18,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.1,
                  ),
                  width: width * 0.3,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(hostImg + widget.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 18,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            widget.decrement();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Center(
                                child: Text(
                              "-",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Text(
                            widget.total.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.increment();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: mainColor,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Center(
                                child: Text(
                              "+",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.11,
      color: Colors.white,
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
                  "\$${widget.totalPrice}",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                GestureDetector(
                  onTap: (){
                    widget.buy();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0XFFFFB039),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Buy (${widget.total} Item)",
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
