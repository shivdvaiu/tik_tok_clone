import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/business_logic/models/video_model/video_model.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';

class VideoProvider extends ChangeNotifier {
  List<Video> _videoList = [];

  List<Video> get videoList => _videoList;

  final FirebaseStorage firebaseStorage = serviceLocator.get<FirebaseStorage>();
  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  getVideos() {
    log("in get videos");
   firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }

      _videoList = retVal;
      notifyListeners();
      
    });


  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = firebaseAuth.currentUser!.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
