import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/constants/loading_status.dart';
import '/constants/logger.dart';
import '/controllers/home_ctrl/electronic_ctrl.dart';
import '/models/electronic_model/electronic_model.dart';
import '../../../constants/color.dart';
import '../../../constants/url_base.dart';
import '/widgets/common_gride_view.dart';
import 'view_detail_item_view.dart';

class ElectronicView extends StatefulWidget {
  const ElectronicView({super.key});

  @override
  State<ElectronicView> createState() => _ElectronicViewState();
}

class _ElectronicViewState extends State<ElectronicView> {
  @override
  void initState() {
    "Start integrete".log();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ElectronicCtrl>().setLoading();
      context.read<ElectronicCtrl>().readElectronic();
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
      title: const Text("Electronic"),
      titleSpacing: -13,
    );
  }

  Widget _buildBody() {
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
      return _buildGridItem();
    }
  }

  Widget _buildGridItem() {
    ElectronicModel electronicModel =
        context.watch<ElectronicCtrl>().electronicModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double itemHeight = (height - kToolbarHeight - width * 0.6) / 2;
    final double itemWidth = width / 2;
    if (electronicModel.data.isEmpty) {
      return const Center(
          child: Text(
        "No Product",
        style: TextStyle(
          fontSize: 30,
        ),
      ));
    } else {
      electronicModel;
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ElectronicCtrl>().setLoading();
        context.read<ElectronicCtrl>().readElectronic();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GridView.builder(
            itemCount: electronicModel.data.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (context, index) {
              var data = electronicModel.data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewDetailItemElectronic(
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
