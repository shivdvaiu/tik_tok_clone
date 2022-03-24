import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tik_tok_clone/business_logic/utils/routes/routes.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';
import 'package:tik_tok_clone/business_logic/view_models/comment_view_model/comment_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/login_view_model/login_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/profile_view_model/profile_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/search_view_model/search_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/sign_up_view_model/sign_up_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/theme_view_model/theme_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/upload_video_view_model/upload_video_view_model.dart';
import 'package:tik_tok_clone/business_logic/view_models/video_show_provider/video_show_provider.dart';
import 'package:tik_tok_clone/services/database/database_keys/data_base_keys.dart';
import 'package:tik_tok_clone/services/database/database_service/database_service.dart';
import 'package:tik_tok_clone/ui/app_theme/app_theme.dart';
import 'package:tik_tok_clone/ui/views/auth/login/login.dart';
import 'package:tik_tok_clone/ui/views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await setupServiceLocator();
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  bool isUserLoggedIn = _preferences.getBool(DbKeys.isUserLoggedIn) ?? false;

  runApp(Sizer(
    builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(
            create: (_) => SignUpViewModel(),
          ),
          ChangeNotifierProvider(
              create: (_) => ThemeViewModel(AppTheme.darkTheme)),
          ChangeNotifierProvider(create: (_) => UploadVideoProvider()),
          ChangeNotifierProvider(create: (_) => VideoProvider()),
          ChangeNotifierProvider(
              create: (_) => CommentProvider()..getComment()),
         
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: TikTokClone(isUserLoggedIn: isUserLoggedIn),
      );
    },
  ));
}

class TikTokClone extends StatelessWidget {
  final isUserLoggedIn;

  TikTokClone({required this.isUserLoggedIn});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
        builder: (context, themeProvider, child) => MaterialApp(
            routes: Routes.routes,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(),
            home: isUserLoggedIn == false ? LoginScreen() : HomeScreen()));
  }
}
