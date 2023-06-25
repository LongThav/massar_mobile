
import 'package:flutter/material.dart';
import 'package:project/constants/size_constan.dart';

import 'color.dart';

const kTextInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: AppColors.indyBlue,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.indyBlue, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.indyBlue, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(Sizes.dimen_10),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.5),
    borderRadius: BorderRadius.all(
      Radius.circular(Sizes.dimen_10),
    ),
  ),
);