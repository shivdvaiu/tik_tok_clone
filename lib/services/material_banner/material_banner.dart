import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

showMaterialBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showMaterialBanner(
   MaterialBanner(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(text,style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: 11.sp),), actions: [],
    ),
  );
}