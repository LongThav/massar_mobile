import 'package:flutter/material.dart';
import 'package:project/utils/constants/url_base.dart';
import 'package:project/utils/ulti_push.dart';
import 'package:project/widgets/common_view_index_item.dart';

class DetialProHomeView extends StatefulWidget {
  final int id;
  final String name;
  final String sellerName;
  final String price;
  final String image;
  final String discount;
  final String? rate;
  const DetialProHomeView(
      {super.key,
      required this.id,
      required this.name,
      required this.sellerName,
      required this.price,
      required this.image,
      required this.discount,
      this.rate});

  @override
  State<DetialProHomeView> createState() => _DetialProHomeViewState();
}

class _DetialProHomeViewState extends State<DetialProHomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewDetailItemByFilter(
        name: widget.name,
        sellerName: widget.sellerName,
        price: widget.price,
        image: hostImg + widget.image,
        discount: widget.discount,
        id: widget.id,
        increment: (){},
        decrement: (){},
        gotoCart: (){},
        totalItem: 0,
        clearList: (){
          print("Back");
          backPage(context);
        },
        commment: TextEditingController(),
        submitComment: (){},
        title: 'Electronic');
  }
}
