import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sizer/sizer.dart';
import 'package:tik_tok_clone/services/image_picker/pick_image.dart';

Future<dynamic> selectImage(
    BuildContext parentContext, dynamic provider) async {
  return showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Create a Post',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Theme.of(context).colorScheme.surface, fontSize: 10.sp)),
        children: <Widget>[
          SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Text('Take a photo',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 10.sp)),
              onPressed: () async {
                     Navigator.pop(context);
                provider.setPostImage =
                    await pickImage(ImageSource.camera);
              }),
          SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: Text('Choose from Gallery',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 10.sp)),
              onPressed: () async {
                Navigator.pop(context);
              provider.setPostImage =
                    await pickImage(ImageSource.gallery);
              }),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text("Cancel",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 10.sp)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
