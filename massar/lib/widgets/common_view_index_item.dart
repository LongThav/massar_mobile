import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '/constants/color.dart';
import '/constants/logger.dart';


class ViewDetailItemByFilter extends StatefulWidget {
  final int id;
  final String name;
  final String sellerName;
  final String price;
  final String image;
  final String discount;
  final String? rate;
  final TextEditingController commment;
  final int totalItem;
  final VoidCallback submitComment;
  final VoidCallback clearList;
  final VoidCallback increment;
  final VoidCallback decrement;
  final VoidCallback gotoCart;
  final String title;
  const ViewDetailItemByFilter(
      {super.key,
      required this.name,
      required this.sellerName,
      required this.price,
      required this.image,
      required this.discount,
      this.rate,
      required this.id,  required this.increment, required this.decrement, required this.gotoCart, required this.totalItem, required this.clearList, required this.commment, required this.submitComment, required this.title});

  @override
  State<ViewDetailItemByFilter> createState() => _ViewDetailItemByFilterState();
}

class _ViewDetailItemByFilterState extends State<ViewDetailItemByFilter>
    with TickerProviderStateMixin {
  final TextEditingController _commentCtrl = TextEditingController();
  var _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          // onPressed: () {
  
          // },
          onPressed: widget.clearList,
        ),
        titleSpacing: -13,
        title: Text(widget.title),
        elevation: 0.0,
      ),
      bottomNavigationBar: _buildBottom(),
      body: _builBody(),
    );
  }

  Widget _builBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    "${widget.rate}".log;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.3,
            color: mainCover,
            child: Center(
              child: Image.network(
                widget.image,
                height: height * 0.25,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 15, top: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          Container(
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              child: Text(
               "\$${widget.price}",
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Image.network(widget.image),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.sellerName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.5),
                    )),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 1,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    "$rating".log();
                  },
                ),
                Text(widget.rate ?? "0"),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.17),
                  child: Text(
                    widget.discount,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TabBar(
            onTap: (value) {},
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            indicatorColor: mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            labelPadding: const EdgeInsets.only(bottom: 15),
            controller: _controller,
            labelColor: mainColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Text(
                "Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Review",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: width,
            height: height * 0.3,
            child: TabBarView(
              controller: _controller,
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Spesification",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '- ${widget.name} \n',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.grey),
                          ),
                          TextSpan(
                            text: '- ${widget.sellerName} \n',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.grey),
                          ),
                          TextSpan(
                            text: '- ${widget.price} \n',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.grey),
                          ),
                          TextSpan(
                            text: '- ${widget.discount}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: widget.commment,
                          decoration: InputDecoration(
                              hintText: 'Leave comment',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    widget.submitComment();
                                  },
                                  icon: const Icon(Icons.comment_outlined))),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height * 0.1,
      child: Row(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.decrement();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                widget.totalItem.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.increment();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: mainColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context){
              //   return CartListView(cartModel: _cartModel);
              // }));
              widget.gotoCart();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: width * 0.55,
              height: height * 0.8,
              decoration: BoxDecoration(
                color: const Color(0XFFFFB039),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Text(
                "Add to Cart",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
