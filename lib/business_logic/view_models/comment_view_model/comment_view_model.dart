import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/business_logic/models/user_comment_model/comment_model.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';

class CommentProvider extends ChangeNotifier {
  final List<Comment> _comments = [];
  List<Comment> get comments => _comments;
  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();
  String _postId = "";
  final FirebaseFirestore firestore = serviceLocator.get<FirebaseFirestore>();
  
final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map(
      (QuerySnapshot query) {
        List<Comment> retValue = [];
        for (var element in query.docs) {
          retValue.add(Comment.fromSnap(element));
        }
        return retValue;
      },
    );

    notifyListeners();
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get();
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: firebaseAuth.currentUser!.uid,
          id: 'Comment $len',
        );
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(
              comment.toJson(),
            );
        DocumentSnapshot doc =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  likeComment(String id) async {
    var uid = firebaseAuth.currentUser!.uid;
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
