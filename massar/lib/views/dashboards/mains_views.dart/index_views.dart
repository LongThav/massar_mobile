import 'package:flutter/material.dart';
import 'package:project/controllers/auth_ctrls/auth_firebase_ctrl.dart';
import 'package:project/controllers/home_ctrl/electronic_ctrl.dart';
import 'package:project/controllers/home_ctrl/home_ctrl.dart';
import 'package:project/models/cart_model.dart';
import 'package:project/views/dashboards/drawers/seller_view.dart';
import 'package:project/views/dashboards/home_views/chats/list_chating_view.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../home_views/shopping_carts/cart_view.dart';
import '/constants/logger.dart';
import '/constants/snack_bar.dart';
import '/controllers/auth_ctrls/auth_ctrl.dart';
import '../../../controllers/profile_ctrl/profile_ctrl.dart';
import '/views/auths/login_view.dart';
import '../../../constants/list_default_view.dart';
import '../../../constants/list_icon_setting.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int index = 0;
  String _title = "Home";

  bool isSelect = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ElectronicCtrl>().readCart();
    });
    super.initState();
  }

  Future<void> _showDialogLogout() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              height: MediaQuery.of(context).size.height * 0.1,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      "click no".log();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.read<ProfileController>().logout().then((value) {
                        if (value == true) {
                          context.read<AuthFirebaseController>().signOuController();
                          Future.delayed(const Duration(milliseconds: 400), () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginView();
                            }), (route) => false);
                            context.read<ElectronicCtrl>().deleteTable();
                            context.read<AuthController>().setLoading(false);
                            snackBar(context, "Logout successfully");
                          });
                        } else {
                          snackBar(context, "fails logout");
                        }
                      });
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: const Color(0XFF06AB8D),
        title: Text(_title),
        leading: IconButton(
            onPressed: () {
              _key.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 35,
            )),
        elevation: 0.0,
        actions: [
          _buildSMS(),
          const SizedBox(
            width: 0,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                size: 30,
              )),
          const SizedBox(
            width: 0,
          ),
          Container(
              padding: const EdgeInsets.only(right: 15, top: 15),
              child: _shoppingCartBadge()),
        ],
      ),
      drawer: _buildDrawer(),
      body: viewIndex[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
            if (index == 0) {
              _title = "Home";
            } else if (index == 1) {
              _title = "Feeds";
            } else if (index == 2) {
              _title = "Transaction";
            } else if (index == 3) {
              _title = "My Profile";
            }
          });
        },
        iconSize: 35,
        elevation: 0,
        unselectedItemColor: const Color(0XFF8B9E9E),
        selectedItemColor: const Color(0XFFE98E06),
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
          BottomNavigationBarItem(
              icon: Icon(Icons.transfer_within_a_station),
              label: 'Transaction'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'My Profile'),
        ],
      ),
    );
  }

  Widget _shoppingCartBadge() {
    List<CartModel> status = context.watch<ElectronicCtrl>().cartModel;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const CartView();
        }));
      },
      child: badges.Badge(
        badgeContent: Text(status.length.toString()),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildSMS(){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<int> count = context.read<HomeController>().statusMsg;
    debugPrint("status chat: ${count.length}");
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return const ListChatingView();
        }));
      },
      child: Padding(
        padding:  EdgeInsets.only(top: height * 0.02, right: width * 0.02),
        child:  badges.Badge(
          badgeContent: Text(count.length.toString()),
          child: const Icon(Icons.sms_outlined),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final hegiht = MediaQuery.of(context).size.height;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5, top: 5),
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                  size: 30,
                )),
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, top: 0),
              alignment: Alignment.centerLeft,
              child: Image.asset(massar)),
          SizedBox(
            height: hegiht * 0.08,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Total Payment",
                      style: TextStyle(
                        color: Color(0XFF8B9E9E),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\$0",
                      style: TextStyle(
                        color: Color(0XFF06AB8D),
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                Container(
                  height: hegiht * 0.055,
                  width: 1.5,
                  color: const Color(0XFF8B9E9E),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Total payments",
                      style: TextStyle(
                        color: Color(0XFF8B9E9E),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "0 point",
                      style: TextStyle(
                        color: Color(0XFFFFB039),
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: hegiht * 0.045,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              children: List.generate(iconDrawer.length, (index) {
                return GestureDetector(
                  onTap: () {
                    if (iconDrawer[index]['icon'] == Icons.person_outline ||
                        iconDrawer[index]['title'] == 'Become Seller') {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const SellerView();
                          }));
                    }else{
                      snackBar(context, "Comming soon");
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 8),
                        child: Icon(iconDrawer[index]['icon'],
                            size: 30,
                            // color: iconDrawer[index]['isSelect'] == true ? selectColor : unSelectColor,
                            color: selectColor),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        iconDrawer[index]['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelect ? selectColor : unSelectColor,
                            fontSize: 18),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            height: hegiht * 0.06,
          ),
          InkWell(
            onTap: _showDialogLogout,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 30,
                    color: selectColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelect ? selectColor : unSelectColor,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
