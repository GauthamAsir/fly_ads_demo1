import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/utils/my_video_player.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  dynamic videoUrl =
      'https://firebasestorage.googleapis.com/v0/b/stockwiki-ce6c7.appspot.com/o/SampleVideo_1280x720_10mb.mp4?alt=media&token=ab92b7f3-026c-4e99-91ba-bc841bac2a54';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: MyVideoPlayer(path: videoUrl)),
    );
  }
}
