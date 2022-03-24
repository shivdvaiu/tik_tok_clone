import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clone/business_logic/view_models/comment_view_model/comment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatefulWidget {
  final String id;
  CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentProvider = TextEditingController();

  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<CommentProvider>().updatePostId(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  

    return Scaffold(
      body: Consumer<CommentProvider>(builder: (BuildContext context, commentProvider, Widget? child)=>SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                      itemCount: commentProvider.comments.length,
                      itemBuilder: (context, index) {
                        final comment = commentProvider.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(comment.profilePhoto),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "${comment.username}  ",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                comment.comment,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                tago.format(
                                  comment.datePublished.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${comment.likes.length} likes',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () =>
                                commentProvider.likeComment(comment.id),
                            child: Icon(
                              Icons.favorite,
                              size: 25,
                              color: comment.likes
                                      .contains(firebaseAuth.currentUser!.uid)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        );
                      });
                }),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentProvider,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      commentProvider.postComment(_commentProvider.text),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
