import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:project/utils/constants/loading_status.dart';
import 'package:project/controllers/home_ctrl/electronic_ctrl.dart';
import 'package:project/models/electronic_model/electronic_model.dart';
import 'package:project/widgets/common_gride_view.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:project/utils/constants/color.dart';
import '../../../utils/ulti_push.dart';
import '../../../utils/constants/snack_bar.dart';
import '/controllers/home_ctrl/home_ctrl.dart';
import '/views/dashboards/home_views/beauty_view.dart';
import '/views/dashboards/home_views/deal_view.dart';
import '/views/dashboards/home_views/f_and_b_view.dart';
import '/views/dashboards/home_views/fashion_view.dart';
import '../../../utils/constants/list_filter_home_view.dart';
import 'detial_pro_home_view.dart';
import 'electronic_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchCtrl = TextEditingController();
  var value = "";

  int _currentIndex = 0;

  CarouselController _switchBanner = CarouselController();

  late LocationData _currentPosition;
  String _address = '';
  Location location = Location();

  // void fetchLocation() async {
  //   bool serviceEnabled;
  //   PermissionStatus permisssionGranted;
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //   permisssionGranted = await location.hasPermission();
  //   if (permisssionGranted == PermissionStatus.denied) {
  //     permisssionGranted = await location.requestPermission();
  //     if (permisssionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   _currentPosition = await location.getLocation();
  //   location.onLocationChanged.listen((LocationData currentLocation) {
  //     setState(() {
  //       _currentPosition = currentLocation;
  //       getAddress(_currentPosition.latitude, _currentPosition.longitude)
  //           .then((value) {
  //         setState(() {
  //           _address = value.first.addressLine;
  //           String countryName = value.first.countryName;
  //           context.read<HomeController>().addAddress(_address);
  //           debugPrint("CountryName: $countryName");
  //           debugPrint("Address now: $_address");
  //         });
  //       });
  //     });
  //   });
  // }

  // Future<List<Address>> getAddress(double? lat, double? lang) async {
  //   final coordinates = Coordinates(lat, lang);
  //   List<Address> address =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return address;
  // }

  @override
  void initState() {
    // fetchLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ElectronicCtrl>().setLoading();
      context.read<ElectronicCtrl>().readElectronic();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              color: mainColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: Text(
                            // _address,
                            '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[300]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          value = value;
                        },
                        // controller: _searchCtrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search product here',
                          suffixIcon: IconButton(
                              onPressed: () {
                                context
                                    .read<HomeController>()
                                    .searchCtrl(value);
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildFilter(),
            _buildBanner(),
            _buildIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Product",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const Text(
                    "View all",
                    style: TextStyle(fontSize: 18, color: mainColor),
                  ),
                ],
              ),
            ),
            _buildElecPro(),
          ],
        ),
      ),
    );
  }

  Widget _buildElecPro() {
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
      return _item();
    }
  }

  Widget _item() {
    ElectronicModel electronicModel =
        context.watch<ElectronicCtrl>().electronicModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double itemHeight = (height - kToolbarHeight - width * 0.6) / 2;
    final double itemWidth = width / 2;
    if (electronicModel.data.isEmpty) {
      return const Center(
        child: Text("No Product"),
      );
    }
    electronicModel;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ElectronicCtrl>().setLoading();
        context.read<ElectronicCtrl>().readElectronic();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: width,
        height: height * 0.33,
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
            return GestureDetector(
              onTap: (){
                pushPage(context,  DetialProHomeView(
                  id: data.id,
                  discount: data.discountPrice ?? "Free",
                  name: data.name,
                  sellerName: data.sellerName,
                  price: data.price,
                  image: data.image,
                ));
              },
              child: CommonGridView(
                  name: data.name,
                  sellerName: data.sellerName,
                  rate: data.rate ?? "0",
                  price: data.price,
                  discountPrice: data.discountPrice ?? "Free",
                  image: DecorationImage(
                      image: NetworkImage(hostImgPro + data.image))),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(listFilter.length, (index) {
          return GestureDetector(
            onTap: () {
              if (listFilter[index]['title'] == 'Electronic' ||
                  listFilter[index]['icon'] == electronic) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ElectronicView();
                }));
              } else if (listFilter[index]['title'] == 'Fashion' ||
                  listFilter[index]['icon'] == fashion) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FashionView();
                }));
              } else if (listFilter[index]['title'] == 'F&B' ||
                  listFilter[index]['icon'] == fandb) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FandBView();
                }));
              } else if (listFilter[index]['title'] == 'Beauty' ||
                  listFilter[index]['icon'] == beauty) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BeautyView();
                }));
              } else if (listFilter[index]['title'] == 'Deals' ||
                  listFilter[index]['icon'] == deal) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const DealView();
                }));
              } else {
                snackBar(context, "Comming soon");
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(listFilter[index]['icon']),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(listFilter[index]['title'])
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.2,
      child: CarouselSlider(
        carouselController: _switchBanner,
        items: List.generate(banner.length, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(banner[index]['banner']),
                    fit: BoxFit.fill)),
          );
        }),
        options: CarouselOptions(
            pageSnapping: true,
            autoPlay: true,
            viewportFraction: 0.7,
            enlargeCenterPage: true,
            aspectRatio: 5 / 2,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            initialPage: 0,
            onPageChanged: (int index, reason) {
              setState(() {
                _currentIndex = index;
              });
            }),
      ),
    );
  }

  Widget _buildIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(banner.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? const Color.fromRGBO(0, 0, 0, 0.8)
                  : const Color.fromRGBO(0, 0, 0, 0.3),
            ),
          );
        }),
      ),
    );
  }
}
