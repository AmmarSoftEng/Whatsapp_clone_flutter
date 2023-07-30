// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/features/chat/widget/type_of_messages.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final String replayText;
  final String userName;
  final MessageEnum replyMessageType;
  final VoidCallback onSwpeLeft;
  final bool isSeen;

  MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum,
    required this.replayText,
    required this.userName,
    required this.replyMessageType,
    required this.onSwpeLeft,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplay = replayText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onSwpeLeft,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReplay) ...[
                          Text(
                            "You",
                            //style: TextStyle(fontWeight: FontWeight.w100),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: backgroundColor.withOpacity(0.7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: MyWidget(
                                message: replayText, type: replyMessageType),
                          ),
                        ],
                        MyWidget(
                          message: message,
                          type: messageEnum,
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      isSeen
                          ? Icon(
                              Icons.done_all,
                              size: 20,
                              color: Colors.white60,
                            )
                          : Icon(
                              Icons.done,
                              size: 20,
                              color: Colors.white60,
                            ),
                    ],
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
