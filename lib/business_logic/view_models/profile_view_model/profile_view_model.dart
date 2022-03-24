import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic> _user = Map<String, dynamic>();

  Map<String, dynamic> get user => _user;

  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();

  String _postId = "";
  final FirebaseFirestore firestore = serviceLocator.get<FirebaseFirestore>();

  String _uid = serviceLocator.get<FirebaseAuth>().currentUser!.uid;

  updateUserId(String uid) {
    _uid = uid;
    notifyListeners();
    getUserData();
  }

  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['username'];
    String profilePhoto = userData['photoUrl'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid)
        .collection('followers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    notifyListeners();
  }

  followUser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid)
        .collection('followers')
        .doc(_uid)
        .get();

    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('followers')
          .doc(_uid)
          .set({});
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('following')
          .doc(_uid)
          .set({});
      _user.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );

      notifyListeners();
    } else {
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('followers')
          .doc(_uid)
          .delete();
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('following')
          .doc(_uid)
          .delete();
      _user.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.update('isFollowing', (value) => !value);
    notifyListeners();
  }
}
