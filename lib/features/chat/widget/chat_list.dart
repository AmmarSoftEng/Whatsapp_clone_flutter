// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/common/provider/replay_provider.dart';
import 'package:whatsapp/common/widget/loder.dart';
import 'package:whatsapp/features/chat/controller/chart_controller.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/widgets/my_message_card.dart';
import 'package:whatsapp/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  String reciverId;
  bool isGroup;
  ChatList({
    required this.reciverId,
    required this.isGroup,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageScroller = ScrollController();

  @override
  void dispose() {
    messageScroller.dispose();
    super.dispose();
  }

  void onswipMessage(String message, MessageEnum type, bool isMe) {
    ref.read(messageReplyProvider.notifier).update(
        (state) => ReplayProvider(message: message, type: type, isMe: isMe));
  }

  void isSeenMessage(String recieverUid, String messageId) {
    ref
        .read(chartControllerProvider)
        .setChartMessageSeen(context, recieverUid, messageId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroup
            ? ref
                .read(chartControllerProvider)
                .groupChatStream(widget.reciverId)
            : ref.watch(chartControllerProvider).getMessage(widget.reciverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Loder();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (messageScroller.hasClients) {
              messageScroller.jumpTo(
                messageScroller.position.maxScrollExtent,
              );
            }
            // messageScroller.jumpTo(messageScroller.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageScroller,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];

              if (messageData.recieverid ==
                      FirebaseAuth.instance.currentUser!.uid &&
                  !messageData.isSeen) {
                isSeenMessage(widget.reciverId, messageData.messageId);
              }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(messageData.timeSent),
                  messageEnum: messageData.type,
                  replyMessageType: messageData.repliedMessageType,
                  replayText: messageData.repliedMessage,
                  onSwpeLeft: () =>
                      onswipMessage(messageData.text, messageData.type, true),
                  userName: messageData.repliedTo,
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                messageEnum: messageData.type,
                date: DateFormat.Hm().format(messageData.timeSent),
                replyMessageType: messageData.repliedMessageType,
                replayText: messageData.repliedMessage,
                onSwpeRight: () =>
                    onswipMessage(messageData.text, messageData.type, false),
                userName: messageData.repliedTo,
              );
            },
          );
        });
  }
}
