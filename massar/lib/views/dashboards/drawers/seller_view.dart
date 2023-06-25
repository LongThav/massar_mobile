import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/loading_status.dart';
import 'package:project/constants/url_base.dart';
import 'package:project/controllers/feeds/feeds_ctrl.dart';
import 'package:project/controllers/profile_ctrl/profile_ctrl.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../../../models/auth_model/login_model.dart';

class SellerView extends StatefulWidget {
  const SellerView({super.key});

  @override
  State<SellerView> createState() => _SellerViewState();
}

class _SellerViewState extends State<SellerView> {
  late DateTime now;
  late String formattedDate;
  TextEditingController _typingCtrl = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileController>().setLoading(context);
      context.read<ProfileController>().readLocalProfile();
    });
    now = DateTime.now();
    formattedDate = DateFormat.yMMMEd().format(now);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Post Your Product"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloat(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget _buildBody() {
    LoadingStatus loadingStatus =
        context.watch<ProfileController>().loadingStatus;
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
      return _buildView();
    }
  }

  Widget _buildView() {
    LoginModel loginModel = context.watch<ProfileController>().loginModel;
    // File? img = context.read<FeedController>().imgFile;
    // debugPrint("imag: $img");
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 40,
                child: Image.network(loginModel.data.user.image == null
                    ? staticImg
                    : hostImg + loginModel.data.user.image.toString()),
              ),
              Padding(
                padding:  EdgeInsets.only(right: width * 0.14,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loginModel.data.user.fullname,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]?.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 8,),
                    Text(formattedDate.toString())
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.blue)
                ),
                child: Text("Post",
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]
                ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: TextField(
              maxLines: 2,
              controller: _typingCtrl,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'typing...'
              ),
            ),
          ),
          SizedBox(height: height * 0.06,),
          Container(
            width: width,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // image: DecorationImage(
              //   image: MemoryImage(File(img.path))
              // )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloat(){
    return FloatingActionButton(
      splashColor: Colors.blue,
      isExtended: false,
      backgroundColor: mainColor,
      elevation: 1,
      onPressed: (){
        context.read<FeedController>().openImage();
      },
      child: const Icon(Icons.image_outlined),
    );
  }
}
