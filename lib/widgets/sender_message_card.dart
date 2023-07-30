// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/features/chat/widget/type_of_messages.dart';

class SenderMessageCard extends StatelessWidget {
  SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum,
    required this.replayText,
    required this.userName,
    required this.replyMessageType,
    required this.onSwpeRight,
  }) : super(key: key);

  final String message;
  final String date;
  final MessageEnum messageEnum;
  final String replayText;
  final String userName;
  final MessageEnum replyMessageType;
  final VoidCallback onSwpeRight;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: onSwpeRight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 30,
                      top: 5,
                      bottom: 20,
                    ),
                    child: MyWidget(message: message, type: messageEnum)),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
