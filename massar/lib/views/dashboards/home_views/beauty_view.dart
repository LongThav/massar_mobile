import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/beauty_model.dart/beauty_model.dart';
import '/controllers/home_ctrl/beauty_ctrl.dart';
import '../../../constants/color.dart';
import '../../../constants/loading_status.dart';
import '../../../constants/url_base.dart';
import '../../../widgets/common_gride_view.dart';


class BeautyView extends StatefulWidget {
  const BeautyView({super.key});

  @override
  State<BeautyView> createState() => _BeautyViewState();
}

class _BeautyViewState extends State<BeautyView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BeautyController>().setLoading();
      context.read<BeautyController>().readBeauty();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: body,
      appBar: _buildAppBar,
      body: _buildBody(),
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: const Color(0XFF06AB8D),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text("Beauty"),
      titleSpacing: -13,
    );
  }

  Widget _buildBody() {
    LoadingStatus loadingStatus =
        context.watch<BeautyController>().loadingStatus;
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
      return _buildGridItem();
    }
  }

  Widget _buildGridItem() {
    BeautyModel beautyModel = context.watch<BeautyController>().beautyModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double itemHeight = (height - kToolbarHeight - width * 0.6) / 2;
    final double itemWidth = width / 2;
    if (beautyModel.data.isEmpty) {
      return const Center(
          child: Text(
        "No Product",
        style: TextStyle(
          fontSize: 30,
        ),
      ));
    } else {
      beautyModel;
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<BeautyController>().setLoading();
        context.read<BeautyController>().readBeauty();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GridView.builder(
            itemCount: beautyModel.data.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (context, index) {
              var data = beautyModel.data[index];
              return InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return ViewDetailItem(
                  //       id: data.id,
                  //       name: data.name,
                  //       sellerName: data.sellerName,
                  //       price: data.price,
                  //       image: data.image,
                  //       discount: data.discountPrice ?? "Free",
                  //       rate: data.rate ?? "0");
                  // }));
                },
                child: CommonGridView(
                    name: data.name,
                    sellerName: data.sellerName,
                    rate: data.rate ?? "0",
                    price: '${data.price}\$',
                    discountPrice: data.discountPrice ?? "Free",
                    image: DecorationImage(
                        image: NetworkImage(hostImg + data.image))),
              );
            }),
      ),
    );
  }
}
