import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tik_tok_clone/business_logic/utils/constants/constants.dart';
import 'package:tik_tok_clone/business_logic/utils/enums/enums.dart';

class LoginViewModel extends ChangeNotifier  {
  TextEditingController loginEmailEditingController = TextEditingController();
  TextEditingController loginPasswordEditingController =
      TextEditingController();

  Future<SignInState> signInWithEmailAndPassword(
      {required String email, required password}) async {
    log(email);
    log(password);
    try {
dynamic userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == Constants.userNotFound) {
        return SignInState.USER_NOT_FOUND;
      } else if (e.code == Constants.wrongPassword) {
        return SignInState.WRONG_PASSWORD;
      } else if (e.code == Constants.invalidEmail) {
        return SignInState.INVALID_EMAIL;
      } else {
        log(e.code);
        return SignInState.UNKNOWN_ERROR;
      }
    }

    return SignInState.SIGN_IN_SUCCESS;
  }

  clearLoginInfo() {
    loginEmailEditingController.clear();
    loginPasswordEditingController.clear();
  }

  
}
