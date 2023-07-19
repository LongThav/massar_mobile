import 'dart:developer' as devs show log;

import 'package:flutter/cupertino.dart';

extension Logger on Object {
  // declare extension .log
  void log() => devs.log(toString());
}


class KeyboardUtils {
  static bool isKeyboardShowing() {
    if (WidgetsBinding.instance != null) {
      return WidgetsBinding.instance.window.viewInsets.bottom > 0;
    } else {
      return false;
    }
  }

  static closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

