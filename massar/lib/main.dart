import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/controllers/home_ctrl/home_ctrl.dart';
import '/controllers/home_ctrl/beauty_ctrl.dart';
import '/controllers/home_ctrl/electronic_ctrl.dart';
import '/controllers/home_ctrl/f_and_b_ctrl.dart';
import '/controllers/home_ctrl/fashion_ctrl.dart';
import 'controllers/auth_ctrls/auth_ctrl.dart';
import 'controllers/auth_ctrls/auth_firebase_ctrl.dart';
import 'controllers/feeds/feeds_ctrl.dart';
import 'controllers/home_ctrl/deal_controller.dart';
import 'controllers/profile_ctrl/profile_ctrl.dart';
import 'controllers/push_notification_ctrl/push_notification_ctrl.dart';
import 'views/dashboards/mains_views.dart/splash_view.dart';
import 'controllers/chat_ctrl/chat_ctrl.dart';
import 'controllers/chat_ctrl/home_chat_ctrl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationAPI().initNotifications();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(
            create: (context) => AuthFirebaseController(
                firebaseAuth: FirebaseAuth.instance,
                firebaseFirestore: firebaseFirestore,
                sharedPreferences: sharedPreferences)),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => ElectronicCtrl()),
        ChangeNotifierProvider(create: (context) => FeedController()),
        ChangeNotifierProvider(create: (context) => FashionController()),
        ChangeNotifierProvider(create: (context) => FANDBController()),
        ChangeNotifierProvider(create: (context) => BeautyController()),
        ChangeNotifierProvider(create: (context) => DealController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        Provider<HomeChatController>(
          create: (context) =>
              HomeChatController(firebaseFirestore: firebaseFirestore),
        ),
        Provider<ChatController>(
          create: (context) => ChatController(
              sharedPreferences: sharedPreferences,
              firebaseStorage: firebaseStorage,
              firebaseFirestore: firebaseFirestore),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}

//user1
// email: longthavsipav69@gmail.com
// password: longthavsipav01

//user2
//email: pav4463@gmail.com
//password: sipav123
