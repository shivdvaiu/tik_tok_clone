import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tik_tok_clone/business_logic/utils/routes/routes.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';
import 'package:tik_tok_clone/business_logic/view_models/profile_view_model/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      context.read<ProfileProvider>().updateUserId(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
      if (profileProvider.user.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          leading: const Icon(
            Icons.person_add_alt_1_outlined,
          ),
          actions: const [
            Icon(Icons.more_horiz),
          ],
          title: Text(
            profileProvider.user['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: profileProvider.user['profilePhoto'],
                              height: 100,
                              width: 100,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                profileProvider.user['following'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.black54,
                            width: 1,
                            height: 15,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                profileProvider.user['followers'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.black54,
                            width: 1,
                            height: 15,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                profileProvider.user['likes'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Likes',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 140,
                        height: 47,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              if (widget.uid == firebaseAuth.currentUser!.uid) {
                                SharedPreferences _preferences =
                                    await SharedPreferences.getInstance();
                                    firebaseAuth.signOut();
                                _preferences.clear();

                                Navigator.pushNamed(
                                    context, Routes.loginScreen);
                              } else {
                                profileProvider.followUser();
                              }
                            },
                            child: Text(
                              widget.uid == firebaseAuth.currentUser!.uid
                                  ? 'Sign Out'
                                  : profileProvider.user['isFollowing']
                                      ? 'Unfollow'
                                      : 'Follow',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      // video list
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileProvider.user['thumbnails'].length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          String thumbnail =
                              profileProvider.user['thumbnails'][index];
                          return CachedNetworkImage(
                            imageUrl: thumbnail,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
