import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

showCircularProgressBar({required BuildContext context}) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: WillPopScope(
            onWillPop: () {
              return Future.value(true);
            },
            child: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            )),
          ),
        );
      });
}
