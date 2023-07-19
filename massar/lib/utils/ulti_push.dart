import 'package:flutter/material.dart';

void pushPage(BuildContext context, dynamic route){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return route;
  }));
}

void pushReplacePage(BuildContext context, dynamic route){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
    return route;
  }));
}

void backPage(BuildContext context){
  Navigator.pop(context);
}