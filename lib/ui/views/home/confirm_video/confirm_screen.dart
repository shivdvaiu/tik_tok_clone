import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clone/business_logic/utils/enums/enums.dart';
import 'package:tik_tok_clone/business_logic/view_models/upload_video_view_model/upload_video_view_model.dart';
import 'package:tik_tok_clone/services/dialogs/circular_progress_bar.dart';
import 'package:tik_tok_clone/ui/widgets/text_field/custom_text_field.dart';

import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                controller.play();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: VideoPlayer(controller),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: CustomTextField(
                      hintText: "Song Name",
                      textEditingController: _songController,
                      icon: Icons.music_note,
                      textInputType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: CustomTextField(
                      textEditingController: _captionController,
                      hintText: 'Caption',
                      icon: Icons.closed_caption,
                      textInputType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showCircularProgressBar(context: context);
                        context
                            .read<UploadVideoProvider>()
                            .uploadVideo(_songController.text,
                                _captionController.text, widget.videoPath)
                            .then((value) {
                          switch (value) {
                            case UPLOAD_VIDEO_STATE.VIDEO_UPLOADED:
                              Navigator.pop(context);
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                              break;
                            case UPLOAD_VIDEO_STATE.VIDEO_UPLOADED_FAILED:
                              Navigator.pop(context);
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                              break;
                            default:
                          }
                        });
                      },
                      child: const Text(
                        'Share!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
