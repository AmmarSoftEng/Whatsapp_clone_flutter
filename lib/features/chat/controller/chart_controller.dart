// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/common/provider/replay_provider.dart';
import 'package:whatsapp/features/auth/controller/auth_contriller.dart';

import 'package:whatsapp/features/chat/repository/chart_repository.dart';
import 'package:whatsapp/model/group.dart';
import 'package:whatsapp/model/message.dart';

import '../../../model/chat_collection_modle.dart';

final chartControllerProvider = Provider((ref) => ChartController(
    charthRepository: ref.read(chartRepositoryProvider), ref: ref));

class ChartController {
  CharthRepository charthRepository;
  Ref ref;

  ChartController({
    required this.charthRepository,
    required this.ref,
  });

  void sendMessage(BuildContext context, String lastMessage, String reciverId,
      bool isGroup) {
    final messagereplay = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        charthRepository.sendMessage(
            context: context,
            lastMessage: lastMessage,
            reciverId: reciverId,
            senderUser: value!,
            replayProvider: messagereplay,
            isGroup: isGroup));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContact>> getContactList() {
    return charthRepository.chartContact();
  }

  Stream<List<Message>> getMessage(String recieverId) {
    return charthRepository.getMessages(recieverId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return charthRepository.getGroupChatStream(groupId);
  }

  Stream<List<Groups>> getGroup() {
    return charthRepository.getGroup();
  }

  void sendphoto(BuildContext context, File file, String reciverId,
      MessageEnum messageEnum, bool isGroup) {
    final messagereplay = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        charthRepository.savePhoto(
            context: context,
            file: file,
            reciverId: reciverId,
            sendUser: value!,
            messageEnum: messageEnum,
            ref: ref,
            replayProvider: messagereplay,
            isGroup: isGroup));
  }

  void setChartMessageSeen(
      BuildContext context, String recieverUid, String messageId) {
    charthRepository.isSeenMessage(context, recieverUid, messageId);
  }
}
