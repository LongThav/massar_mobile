import 'package:flutter/material.dart';

import '../../../utils/constants/check_status_user.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  final CheckStatusUser _checkStatusUser = CheckStatusUser();

  @override
  void initState() {
    _checkStatusUser.checkStatus(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Center(
      child: Image.asset("assets/imgs/massar.png"),
    );
  }
}