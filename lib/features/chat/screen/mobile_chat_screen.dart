// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widget/loder.dart';
import 'package:whatsapp/features/auth/controller/auth_contriller.dart';
import 'package:whatsapp/features/chat/widget/botom_chart_widget.dart';
import 'package:whatsapp/features/chat/widget/chat_list.dart';
import 'package:whatsapp/model/group.dart';
import 'package:whatsapp/model/user_model.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  String name;
  String uid;
  bool isGroup;

  MobileChatScreen({
    required this.name,
    required this.uid,
    required this.isGroup,
  });
  static const routeName = '/mobile_chat_screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: widget.isGroup
            ? StreamBuilder<Groups>(
                stream: ref
                    .watch(authControllerProvider.notifier)
                    .getGroupData(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loder();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name),
                    ],
                  );
                },
              )
            : StreamBuilder<UserModel>(
                stream: ref
                    .watch(authControllerProvider.notifier)
                    .getUserData(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loder();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name),
                      Text(
                        snapshot.data!.isOnline ? "online" : "offline",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              reciverId: widget.uid,
              isGroup: widget.isGroup,
            ),
          ),
          BottomCharField(
            reciverId: widget.uid,
            isGroup: widget.isGroup,
          ),
        ],
      ),
    );
  }
}
