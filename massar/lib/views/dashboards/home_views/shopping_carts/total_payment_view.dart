import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:project/utils/constants/color.dart';
import 'package:project/utils/ulti_push.dart';

class TotalPaymentView extends StatefulWidget {
  final double price;
  const TotalPaymentView({super.key, required this.price});

  @override
  State<TotalPaymentView> createState() => _TotalPaymentViewState();
}

class _TotalPaymentViewState extends State<TotalPaymentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Select Payment"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              backPage(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: const Color(0XFFC0C8C7),
      body: _buildBody,
    );
  }

  Widget get _buildBody {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Summery",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: width,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Total Payment',
                      style: TextStyle(color: Colors.grey[300])),
                  TextSpan(
                      text: '\n \n \$${widget.price}',
                      style: const TextStyle(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Select Card",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)
                  ), 
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: mainColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            LineIcons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      const Text(
                        "Master Card",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/imgs/visa.png',
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Card Number',
                          style: TextStyle(color: Colors.grey[300])),
                      TextSpan(
                          text: '\n'  '**************** 4242',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Card Holder',
                          style: TextStyle(color: Colors.grey[300])),
                      TextSpan(
                          text: '\n'  'LongThav SiPav',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Card Number',
                          style: TextStyle(color: Colors.grey[300])),
                      TextSpan(
                          text: '\n'  '**************** 4141',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Card Holder',
                          style: TextStyle(color: Colors.grey[300])),
                      TextSpan(
                          text: '\n'  'LongThav SiPav',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]))
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05,),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: width * 0.05,),
                      const Text('Paypal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Icon(Icons.paypal, color: Colors.blue[700],)
                ],
              ),
            ),
             SizedBox(height: height * 0.02,),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: width * 0.05,),
                      const Text('Visa Card', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Icon(Icons.paypal, color: Colors.blue[700],)
                ],
              ),
            ),
            SizedBox(height: height * 0.05,),
            Container(
              width: width,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0XFFFFB039),
              ),
              child: const Center(child: Text("Pay Now", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),),
            )
          ],
        ),
      ),
    );
  }
}
