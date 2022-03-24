import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tik_tok_clone/business_logic/utils/enums/enums.dart';
import 'package:tik_tok_clone/business_logic/utils/strings/strings.dart';
import 'package:tik_tok_clone/business_logic/view_models/sign_up_view_model/sign_up_view_model.dart';
import 'package:tik_tok_clone/services/dialogs/circular_progress_bar.dart';
import 'package:tik_tok_clone/services/snack_bar/snack_bar.dart';
import 'package:tik_tok_clone/ui/widgets/elevated_btn.dart';
import 'package:tik_tok_clone/ui/widgets/text_field/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (BuildContext context, signUpProvider, Widget? child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
               
                  SizedBox(
                    height: 1.h,
                  ),
                  signUpProvider.image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(signUpProvider.image!),
                          backgroundColor: Colors.grey,
                        )
                      : Stack(
                          children: [
                            const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(Strings.placeHolderUserImage),
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  signUpProvider.selectImage();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                          ],
                        ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.userName,
                    textInputType: TextInputType.name,
                    textEditingController: signUpProvider.userNameController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.emailHint,
                    textInputType: TextInputType.text,
                    textEditingController: signUpProvider.emailController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.passwordHint,
                    textInputType: TextInputType.text,
                    textEditingController: signUpProvider.passwordController,
                    isObsecure: true,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.confirmHint,
                    textInputType: TextInputType.text,
                    textEditingController:
                        signUpProvider.passwordConfirmController,
                    isObsecure: true,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextField(
                    hintText: Strings.userBio,
                    textInputType: TextInputType.text,
                    textEditingController: signUpProvider.bioController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyElevatedButton(
                      onPressed: () {
                        showCircularProgressBar(context: context);
                        createUser(
                            context: context, signUpProvider: signUpProvider);
                      },
                      buttonName: Strings.signupText,
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
                        text: Strings.alreadyHaveAccount,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 12.sp)),
                    TextSpan(text: '  '),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            signUpProvider.resetUserSignUpInfo();
                            Navigator.pop(context);
                          },
                        text: Strings.loginText,
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

  createUser(
      {required BuildContext context,
      required SignUpViewModel signUpProvider}) {
    signUpProvider
        .signUpUserUsingFirebase(
            bio: signUpProvider.bioController.text,
            email: signUpProvider.emailController.text,
            password: signUpProvider.passwordController.text,
            username: signUpProvider.userNameController.text)
        .then((signUpState) {
      Navigator.pop(context);
      switch (signUpState) {
        case SignUpState.ALREADY_HAVE_ACCOUNT:
          showSnackBar(context, Strings.alreadyHaveAccountError);
          break;
        case SignUpState.WEAK_PASSWORD:
          showSnackBar(context, Strings.weakPassword);
          break;

        case SignUpState.UNKNOWN_ERROR:
          showSnackBar(context, Strings.unknownError);
          break;

        case SignUpState.SIGN_UP_SUCCESS:
          signUpProvider.resetUserSignUpInfo();
          showSnackBar(context, Strings.signUpSucceed);
          Navigator.pop(context);
          break;
        case SignUpState.PASSWORD_NOT_SAME:
          showSnackBar(context, Strings.passwordNotMatch);
          break;

        case SignUpState.VALIDATED_FALSE:
          showSnackBar(context, Strings.fillRequiredInformation);
          break;
        case SignUpState.VALIDATED_TRUE:
          break;
        case SignUpState.SELECT_IMAGE:
          showSnackBar(context, Strings.pleaseUploadImage);
          break;
      }
    });
  }
}
