import 'package:flutter/material.dart';
import 'package:tik_tok_clone/ui/views/auth/login/login.dart';
import 'package:tik_tok_clone/ui/views/auth/sign_up/sign_up.dart';
import 'package:tik_tok_clone/ui/views/home/home.dart';

class Routes {
  Routes._privateConstructor();

  static const String loginScreen = '/login';
  static const String signupScreen = '/signup';
  static const String homeScreen = '/home';
  static const String commentsScreen = '/comments';
  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    loginScreen: (_) => LoginScreen(),
    signupScreen: (_) => SignUpScreen(),
    homeScreen:(_)=>HomeScreen(),
  };
}
