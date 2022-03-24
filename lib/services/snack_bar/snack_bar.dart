import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

showSnackBar(BuildContext context, String text) {
  var snackBar = SnackBar(
     backgroundColor: Theme.of(context).colorScheme.secondary,
    content: Text(text,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white, fontSize: 11.sp)),
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
