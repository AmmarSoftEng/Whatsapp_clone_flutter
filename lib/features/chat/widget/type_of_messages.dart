// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/features/chat/widget/video_widget.dart';

class MyWidget extends StatelessWidget {
  String message;
  MessageEnum type;
  bool isPlay = false;
  AudioPlayer audioPlayer = AudioPlayer();
  MyWidget({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(fontSize: 16),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: BoxConstraints(minWidth: 100),
                    onPressed: () {
                      if (isPlay) {
                        audioPlayer.pause();
                        setState(() {
                          isPlay = false;
                        });
                      } else {
                        audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlay = true;
                        });
                      }
                    },
                    icon: isPlay
                        ? Icon(Icons.pause_circle)
                        : Icon(Icons.play_circle));
              })
            : type == MessageEnum.video
                ? VideoPlayer(video: message)
                : Image.network(message);
  }
}
