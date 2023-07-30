import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  String video;
  VideoPlayer({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController controller;
  bool isPaly = false;
  bool finishedPlaying = false;
  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.video)
      ..initialize().then((value) {
        controller.setVolume(1);
      });

    controller.addListener(() {
      setState(() {});
      if (controller.value.duration == controller.value.position) {
        setState(() {
          isPaly = false;
          finishedPlaying = true;
        });
      } else {
        setState(() {
          finishedPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (finishedPlaying) {
                  controller.seekTo(Duration.zero);
                  controller.play(); // Replay the video
                }
                if (isPaly) {
                  controller.pause();
                } else {
                  controller.play();
                }
                setState(() {
                  isPaly = !isPaly;
                });
              },
              icon: Icon(
                finishedPlaying
                    ? Icons.replay
                    : isPaly
                        ? Icons.pause_circle
                        : Icons.play_circle,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
