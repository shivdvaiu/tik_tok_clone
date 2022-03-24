import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tik_tok_clone/business_logic/utils/enums/enums.dart';
import 'package:tik_tok_clone/business_logic/utils/routes/routes.dart';
import 'package:tik_tok_clone/business_logic/utils/strings/strings.dart';
import 'package:tik_tok_clone/business_logic/view_models/login_view_model/login_view_model.dart';
import 'package:tik_tok_clone/services/database/database_keys/data_base_keys.dart';
import 'package:tik_tok_clone/services/database/database_service/database_service.dart';
import 'package:tik_tok_clone/services/dialogs/circular_progress_bar.dart';
import 'package:tik_tok_clone/services/snack_bar/snack_bar.dart';
import 'package:tik_tok_clone/ui/widgets/elevated_btn.dart';
import 'package:tik_tok_clone/ui/widgets/text_field/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (BuildContext context, loginProvider, Widget? child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  CustomTextField(
                      hintText: Strings.emailHint,
                      textInputType: TextInputType.emailAddress,
                      textEditingController:
                          loginProvider.loginEmailEditingController),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.passwordHint,
                    textInputType: TextInputType.text,
                    textEditingController:
                        loginProvider.loginPasswordEditingController,
                    isObsecure: true,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  MyElevatedButton(
                      onPressed: () {
                        if (loginProvider
                                .loginPasswordEditingController.text.isEmpty ||
                            loginProvider
                                .loginPasswordEditingController.text.isEmpty) {
                          showSnackBar(
                              context, Strings.fillRequiredInformation);
                          return;
                        }
                        showCircularProgressBar(context: context);
                        loginProvider
                            .signInWithEmailAndPassword(
                                email: loginProvider
                                    .loginEmailEditingController.text
                                    .trim(),
                                password: loginProvider
                                    .loginPasswordEditingController.text
                                    .trim())
                            .then((signInState) {
                          Navigator.pop(context);

                          switch (signInState) {
                            case SignInState.USER_NOT_FOUND:
                              showSnackBar(context, Strings.noEmailFound);
                              break;

                            case SignInState.UNKNOWN_ERROR:
                              showSnackBar(context, Strings.unknownError);
                              break;
                            case SignInState.WRONG_PASSWORD:
                              showSnackBar(context, Strings.wrongPassword);
                              break;
                            case SignInState.INVALID_EMAIL:
                              showSnackBar(context, Strings.invalidEmail);
                              break;
                            case SignInState.SIGN_IN_SUCCESS:
                               StorageService().saveToDisk(DbKeys.isUserLoggedIn, true);
                              Navigator.popAndPushNamed(
                                  context, Routes.homeScreen);
                              break;
                            default:
                          }
                        });
                      },
                      buttonName: Strings.loginText,
                      padding: EdgeInsets.symmetric(
                        horizontal: 36.w,
                        vertical: 1.5.h,
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: Strings.dontHaveAccount,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 12.sp)),
                    TextSpan(text: '  '),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, Routes.signupScreen);
                          },
                        text: Strings.signupText,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12.sp,
                            color: Theme.of(context).colorScheme.secondary))
                  ])),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
