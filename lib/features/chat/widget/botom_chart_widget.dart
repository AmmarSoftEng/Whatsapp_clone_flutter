// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/common/provider/replay_provider.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/chat/controller/chart_controller.dart';
import 'package:whatsapp/features/chat/widget/message_replay_preview.dart';

class BottomCharField extends ConsumerStatefulWidget {
  String reciverId;
  bool isGroup;
  BottomCharField({
    required this.reciverId,
    required this.isGroup,
  });

  @override
  ConsumerState<BottomCharField> createState() => _BottomCharFieldState();
}

class _BottomCharFieldState extends ConsumerState<BottomCharField> {
  bool showSendButton = false;
  File? image;
  File? video;
  bool isShowEmoji = false;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  // void openAudio() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException("Mic permission not allowed!");
  //   }
  //   await soundRecorder.openRecorder();
  //   isRecorderinit = true;
  // }
  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendMessage() async {
    if (showSendButton) {
      ref.read(chartControllerProvider).sendMessage(context,
          textEditingController.text.trim(), widget.reciverId, widget.isGroup);

      setState(() {
        textEditingController.text = '';
      });
    } else {
      var temp = await getTemporaryDirectory();
      var pa = '${temp.path}/flutter_scound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await soundRecorder!.stopRecorder();
        sendFileMessage(File(pa), MessageEnum.audio);
      } else {
        await soundRecorder!.startRecorder(toFile: pa);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File image, MessageEnum messageEnum) {
    ref.read(chartControllerProvider).sendphoto(
        context, image, widget.reciverId, messageEnum, widget.isGroup);
  }

  void selectImage() async {
    final result = await pickImage();
    if (result != null) {
      image = File(result.files.first.path!);
      sendFileMessage(image!, MessageEnum.image);
    }
  }

  void selectVideo() async {
    final result = await pickVideo();
    if (result != null) {
      video = File(result.files.first.path!);
      sendFileMessage(video!, MessageEnum.video);
    }
  }

  void showEmoji() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void hideEmoji() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void toggleemojiKeybordContainer() {
    if (isShowEmoji) {
      focusNode.requestFocus();
      hideEmoji();
    } else {
      focusNode.unfocus();
      showEmoji();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagereply = ref.watch(messageReplyProvider);
    final isShoweReplaymessage = messagereply != null;

    return Column(
      children: [
        isShoweReplaymessage ? MessageReplyPreview() : SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      showSendButton = true;
                    });
                  } else {
                    setState(() {
                      showSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: toggleemojiKeybordContainer,
                          icon: Icon(Icons.emoji_emotions),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.gif),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: CircleAvatar(
                backgroundColor: Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendMessage,
                  child: Icon(
                    showSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmoji
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      textEditingController.text =
                          textEditingController.text + emoji.emoji;
                    });
                    if (!showSendButton) {
                      setState(() {
                        showSendButton = true;
                      });
                    }
                  },
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
