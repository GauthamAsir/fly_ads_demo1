import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/utils/constants.dart';
import 'package:fly_ads_demo1/utils/utils.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  final String path;

  const MyVideoPlayer({Key? key, required this.path}) : super(key: key);

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _controller;

  bool focused = true;

  @override
  void initState() {
    String url = widget.path;
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
      });
    log('DataSource: ' + _controller.dataSource);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Stack(
        children: [
          AnimatedContainer(duration: const Duration(milliseconds: 300)),
          _controller.value.isInitialized
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    children: [
                      VideoPlayer(_controller),
                      buildControls(),
                    ],
                  ),
                )
              : Utils.circularLoadingWidget()
        ],
      ),
    );
  }

  Widget buildControls() {
    return Center(
      child: InkWell(
        onTap: () {
          if (_controller.value.isPlaying) {
            if (focused) {
              _controller.pause();
            } else {
              focused = true;
            }
          } else {
            _controller.play();
            focused = false;
          }
          setState(() {});
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: focused
              ? Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        height: 50,
                        width: 50,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: child,
                      ),
                      child: _controller.value.isPlaying
                          ? const Center(
                              key: ValueKey(0),
                              child: Icon(
                                Icons.pause_circle_filled_rounded,
                                color: primaryColor,
                                size: 100,
                              ),
                            )
                          : const Center(
                              key: ValueKey(1),
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: primaryColor,
                                size: 100,
                              ),
                            ),
                    )
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
