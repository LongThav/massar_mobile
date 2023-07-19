import 'package:flutter/material.dart';
import 'package:project/utils/constants/loading_status.dart';
import 'package:project/utils/constants/snack_bar.dart';
import 'package:project/utils/constants/url_base.dart';
import 'package:project/controllers/profile_ctrl/profile_ctrl.dart';
import 'package:project/models/auth_model/login_model.dart';
import 'package:project/views/dashboards/profile_views/update_profile_view.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/list_icon_setting.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileController>().setLoading(context);
      context.read<ProfileController>().readLocalProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _checkStatus(),
    );
  }

  Widget _checkStatus() {
    LoadingStatus loadingStatus =
        context.watch<ProfileController>().loadingStatus;
    if (loadingStatus == LoadingStatus.none ||
        loadingStatus == LoadingStatus.loading) {
      debugPrint("Loading");
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (loadingStatus == LoadingStatus.done) {
      debugPrint("done");
      return _buildBody();
    } else {
      debugPrint("error");
      return const Center(
        child: Text("error"),
      );
    }
  }

  Widget _buildBody() {
    LoginModel loginModel = context.watch<ProfileController>().loginModel;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.28,
            color: const Color(0XFF06AB8D),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 15),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(loginModel.data.user.image ==
                                    null
                                ? staticImg
                                : hostImg +
                                    loginModel.data.user.image.toString()),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Text(
                            loginModel.data.user.fullname,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            loginModel.data.user.phone,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[300]),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      width: width * 0.4,
                      height: height * 0.11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: const Text(
                              "Total payments",
                              style: TextStyle(
                                color: Color(0XFF8B9E9E),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "\$0",
                              style: TextStyle(
                                color: Color(0XFF06AB8D),
                                fontSize: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      width: width * 0.4,
                      height: height * 0.11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: const Text(
                              "My Reward Poin",
                              style: TextStyle(
                                color: Color(0XFF8B9E9E),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "0 point".toUpperCase(),
                              style: const TextStyle(
                                color: Color(0XFFFFB039),
                                fontSize: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          _buildListSetting(loginModel),
        ],
      ),
    );
  }

  Widget _buildListSetting(LoginModel loginModel) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(15),
      height: height * 0.55,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: iconProfile.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                if(iconProfile[index]['icons'] == person || iconProfile[index]['title'] == "User Profile"){
                  context.read<ProfileController>().setUpdateLoading(false);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return  UpdateProfileView(loginModel: loginModel,);
                  }));
                }else{
                  snackBar(context, "Comming soon...");
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Image.asset(iconProfile[index]['icons']),
                  ),
                  title: Text(
                    iconProfile[index]['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(iconProfile[index]['subtitle']),
                ),
              ),
            );
          }),
    );
  }
}
