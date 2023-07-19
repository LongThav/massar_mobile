import 'package:flutter/material.dart';

const String person = "assets/imgs/person.png";
const String notification = "assets/imgs/notification.png";
const String promot = "assets/imgs/promote.png";
const String about = "assets/imgs/question.png";
const String setting = "assets/imgs/setting.png";
const String user= "assets/imgs/user.png";

const String massar = "assets/imgs/massar.png";

List<dynamic> iconProfile = [
  {
    'icons': person,
    'title': 'User Profile',
    'subtitle': 'Consectetur adipiscing elit sedorea',
  },
  {
    'icons': notification,
    'title': 'Notitifactions',
    'subtitle': 'Consectetur adipiscing elit sedorea',
  },
  {
    'icons': promot,
    'title': 'Promotion',
    'subtitle': 'Consectetur adipiscing elit sedorea',
  },
  {
    'icons': about,
    'title': 'About',
    'subtitle': 'Consectetur adipiscing elit sedorea',
  },
  {
    'icons': setting,
    'title': 'Settings',
    'subtitle': 'Consectetur adipiscing elit sedorea',
  },
];

List<dynamic> iconDrawer = [
  {"icon": Icons.home_outlined, "title": "Dashboard", "isSelect": false},
  {"icon": Icons.person_outline, "title": "Become Seller", "isSelect": false},
  {"icon": Icons.category_outlined, "title": "Categories", "isSelect": false},
  {"icon": Icons.badge_outlined, "title": "All Products", "isSelect": false},
  {"icon": Icons.notifications_active_outlined, "title": "Promotion", "isSelect": false},
  {"icon": Icons.question_mark, "title": "Help Center", "isSelect": false},
  {"icon": Icons.settings_outlined, "title": "Settings", "isSelect": false},
];


const Color selectColor = Color(0XFF8B9E9E);
const Color unSelectColor = Color(0XFF06AB8D);