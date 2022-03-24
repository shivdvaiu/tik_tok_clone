import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tik_tok_clone/business_logic/utils/enums/enums.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';
import 'package:video_compress/video_compress.dart';

import 'package:tik_tok_clone/business_logic/models/video_model/video_model.dart';
import 'package:tik_tok_clone/main.dart';

class UploadVideoProvider extends ChangeNotifier {
  final FirebaseStorage firebaseStorage = serviceLocator.get<FirebaseStorage>();
  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();
  final FirebaseFirestore firestore = serviceLocator.get<FirebaseFirestore>();

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {


    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    log(downloadUrl);
    return downloadUrl;
  }

  // upload video
  Future<UPLOAD_VIDEO_STATE> uploadVideo(
      String songName, String caption, String videoPath) async {
            log(videoPath);

    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

          log(uid);
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
        thumbnail: thumbnail,
      );

      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );

      return UPLOAD_VIDEO_STATE.VIDEO_UPLOADED;
    } catch (e) {

      log(e.toString());
      return UPLOAD_VIDEO_STATE.VIDEO_UPLOADED_FAILED;
      // Get.snackbar(
      //   'Error Uploading Video',
      //   e.toString(),
      // );
    }
  }
}
