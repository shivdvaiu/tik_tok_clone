import 'package:flutter/material.dart';
import 'package:tik_tok_clone/ui/app_theme/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeData _themeData;
  bool isLightMode = true;
  ThemeViewModel(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    isLightMode = !isLightMode;
    _themeData = themeData;

    notifyListeners();
  }

  changeTheme() {
    if (isLightMode) {
      setTheme(AppTheme.lightTheme);
    } else {
      setTheme(AppTheme.darkTheme);
    }
  }
}
