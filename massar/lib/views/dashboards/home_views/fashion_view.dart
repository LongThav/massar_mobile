import 'package:flutter/material.dart';
import 'package:project/constants/loading_status.dart';
import 'package:project/constants/url_base.dart';
import 'package:project/models/fashion_model/fashion_model.dart';
import 'package:project/widgets/common_gride_view.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../../../controllers/home_ctrl/fashion_ctrl.dart';
import 'view_detail_item_view.dart';

class FashionView extends StatefulWidget {
  const FashionView({super.key});

  @override
  State<FashionView> createState() => _FashionViewState();
}

class _FashionViewState extends State<FashionView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FashionController>().setLoading();
      context.read<FashionController>().readFashion();
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
      title: const Text("Fashion"),
      titleSpacing: -13,
    );
  }

  Widget _buildBody() {
    LoadingStatus loadingStatus =
        context.watch<FashionController>().loadingStatus;
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
    FashionModel fashionModel = context.watch<FashionController>().fashionModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double itemHeight = (height - kToolbarHeight - width * 0.6) / 2;
    final double itemWidth = width / 2;
    if (fashionModel.data.isEmpty) {
      return const Center(
          child: Text(
        "No Product",
        style: TextStyle(
          fontSize: 30,
        ),
      ));
    } else {
      fashionModel;
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FashionController>().setLoading();
        context.read<FashionController>().readFashion();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GridView.builder(
            itemCount: fashionModel.data.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (context, index) {
              var data = fashionModel.data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewDetailItemFahsion(
                        id: data.id,
                        name: data.name,
                        sellerName: data.sellerName,
                        price: data.price,
                        image: data.image,
                        discount: data.discountPrice ?? "Free",
                        rate: data.rate ?? "0");
                  }));
                },
                child: CommonGridView(
                    name: data.name,
                    sellerName: data.sellerName,
                    rate: data.rate ?? "0",
                    price: data.price,
                    discountPrice: data.discountPrice ?? "Free",
                    image: DecorationImage(
                        image: NetworkImage(hostImg + data.image.toString()))),
              );
            }),
      ),
    );
  }
}
