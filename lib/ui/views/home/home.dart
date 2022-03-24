import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tik_tok_clone/business_logic/utils/service_locator/service_locator.dart';
import 'package:tik_tok_clone/business_logic/view_models/search_view_model/search_view_model.dart';
import 'package:tik_tok_clone/ui/views/home/confirm_video/confirm_screen.dart';
import 'package:tik_tok_clone/ui/views/home/search_screen/search_screen.dart';
import 'package:tik_tok_clone/ui/views/home/video_screen/add_video_screen/add_video_screen.dart';
import 'package:tik_tok_clone/ui/views/home/video_screen/video_screen.dart';
import 'package:tik_tok_clone/ui/views/profile_screen/profile_screen.dart';
import 'package:tik_tok_clone/ui/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final FirebaseAuth firebaseAuth = serviceLocator.get<FirebaseAuth>();

  List screens= [
    VideoScreen(),
  SearchScreen(),
    AddVideoScreen(),
    Text('Messages Screen'),
    ProfileScreen(uid: firebaseAuth.currentUser!.uid),
  ];

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      ); 
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          currentPageIndex = index;

          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
