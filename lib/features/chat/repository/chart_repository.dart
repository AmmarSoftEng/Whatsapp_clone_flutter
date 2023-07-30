// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/enum/enum.dart';
import 'package:whatsapp/common/repository/fierbase_store.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/model/chat_collection_modle.dart';
import 'package:whatsapp/model/group.dart';
import 'package:whatsapp/model/message.dart';
import 'package:whatsapp/model/user_model.dart';
import '../../../common/constants/firebase_constants.dart';
import '../../../common/provider/replay_provider.dart';

final chartRepositoryProvider = Provider(
  (ref) => CharthRepository(
      firestore: ref.read(firestoreProvider), auth: ref.read(authProvider)),
);

class CharthRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  CharthRepository({
    required this.auth,
    required this.firestore,
  });

  CollectionReference get _user =>
      firestore.collection(FirebaseConstants.usersCollection);
  final String _chats = 'chats';
  CollectionReference get _group =>
      firestore.collection(FirebaseConstants.groupCollection);
  //CollectionReference get _chats => firestore.collection(FirebaseConstants.chatsCollection);

  void _saveDataToContactSubCollection(
    UserModel senderUser,
    UserModel? reciverUserData,
    String lastMessage,
    DateTime timeSent,
    String reciverId,
    bool isGroup,
  ) async {
    if (isGroup) {
      await _group.doc(reciverId).update({
        'lastMessage': lastMessage,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var reciverChartContact = ChatContact(
          name: senderUser.name,
          profilePic: senderUser.profilePic,
          contactId: senderUser.uid,
          timeSent: timeSent,
          lastMessage: lastMessage);

      await _user
          .doc(reciverId)
          .collection(_chats)
          .doc(senderUser.uid)
          .set(reciverChartContact.toMap());

      var senderChatContact = ChatContact(
          name: reciverUserData!.name,
          profilePic: reciverUserData.profilePic,
          contactId: reciverUserData.uid,
          timeSent: timeSent,
          lastMessage: lastMessage);

      await _user
          .doc(senderUser.uid)
          .collection(_chats)
          .doc(reciverUserData.uid)
          .set(senderChatContact.toMap());
    }
  }

  void _saveMessageToSubcollection({
    required String reciverUid,
    required String text,
    required DateTime timeSent,
    required UserModel senderUser,
    required String? reciverName,
    required MessageEnum type,
    required messageId,
    required ReplayProvider? replayProvider,
    //required MessageEnum replayMessageType,
    required bool isGroup,
  }) async {
    var message = Message(
      senderId: senderUser.uid,
      recieverid: reciverUid,
      text: text,
      type: type,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: replayProvider == null ? '' : replayProvider.message,
      repliedMessageType:
          replayProvider == null ? MessageEnum.text : replayProvider.type,
      repliedTo: replayProvider == null
          ? ''
          : replayProvider.isMe
              ? senderUser.name
              : reciverName ?? '',
    );
    if (isGroup) {
      await _group
          .doc(reciverUid)
          .collection(_chats)
          .doc(messageId)
          .set(message.toMap());
    } else {
      await _user
          .doc(senderUser.uid)
          .collection(_chats)
          .doc(reciverUid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await _user
          .doc(reciverUid)
          .collection(_chats)
          .doc(senderUser.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendMessage(
      {required BuildContext context,
      required String lastMessage,
      required String reciverId,
      required UserModel senderUser,
      required ReplayProvider? replayProvider,
      required bool isGroup}) async {
    try {
      var timeSent = DateTime.now();
      UserModel? reciverUserData;
      if (!isGroup) {
        var userData = await _user.doc(reciverId).get();
        reciverUserData =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);
      }

      final messageId = Uuid().v4();

      _saveDataToContactSubCollection(senderUser, reciverUserData, lastMessage,
          timeSent, reciverId, isGroup);
      _saveMessageToSubcollection(
          reciverUid: reciverId,
          text: lastMessage,
          timeSent: timeSent,
          senderUser: senderUser,
          reciverName: reciverUserData?.name,
          type: MessageEnum.text,
          messageId: messageId,
          replayProvider: replayProvider,
          isGroup: isGroup);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<ChatContact>> chartContact() {
    return _user
        .doc(auth.currentUser!.uid)
        .collection(_chats)
        .snapshots()
        .map((event) {
      List<ChatContact> constantList = [];
      for (var document in event.docs) {
        constantList.add(ChatContact.fromMap(document.data()));
        // var chartContact = ChatContact.fromMap(document.data());
        // var userData = await _user.doc(chartContact.contactId).get();
        // var user = UserModel.fromMap(userData.data()! as Map<String, dynamic>);
        // constantList.add(ChatContact(
        //     name: user.name,
        //     profilePic: user.profilePic,
        //     contactId: chartContact.contactId,
        //     timeSent: chartContact.timeSent,
        //     lastMessage: chartContact.lastMessage));
      }
      return constantList;
    });
  }

  Stream<List<Message>> getMessages(String reciverId) {
    return _user
        .doc(auth.currentUser!.uid)
        .collection(_chats)
        .doc(reciverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messageList = [];
      for (var document in event.docs) {
        messageList.add(Message.fromMap(document.data()));
      }
      return messageList;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groudId) {
    return _group
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void savePhoto(
      {required BuildContext context,
      required File file,
      required String reciverId,
      required UserModel sendUser,
      required MessageEnum messageEnum,
      required Ref ref,
      required ReplayProvider? replayProvider,
      required bool isGroup}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v4();

      String imageUrl = await ref.read(commonFirebaseStorage).storeFile(
          path:
              'chart/${messageEnum.type}/${sendUser.uid}/$reciverId/$messageId',
          file: file,
          context: context);
      var reciverData;
      if (!isGroup) {
        var userDataMap = await _user.doc(reciverId).get();
        reciverData =
            UserModel.fromMap(userDataMap.data()! as Map<String, dynamic>);
      }
      String contactMessage;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = "📷 photo";
          break;
        case MessageEnum.video:
          contactMessage = "📽️ video";
          break;
        case MessageEnum.audio:
          contactMessage = "🔊 audio";
          break;
        case MessageEnum.gif:
          contactMessage = "gif";
          break;
        default:
          contactMessage = "Gif";
      }
      _saveMessageToSubcollection(
          reciverUid: reciverId,
          text: contactMessage,
          timeSent: timeSent,
          senderUser: sendUser,
          reciverName: reciverData!.name,
          type: messageEnum,
          messageId: messageId,
          replayProvider: replayProvider,
          isGroup: isGroup);

      _saveMessageToSubcollection(
          reciverUid: reciverId,
          text: imageUrl,
          timeSent: timeSent,
          senderUser: sendUser,
          reciverName: reciverData!.name,
          type: messageEnum,
          messageId: messageId,
          replayProvider: replayProvider,
          isGroup: isGroup);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void isSeenMessage(
      BuildContext context, String recieverUid, String messageId) async {
    try {
      await _user
          .doc(recieverUid)
          .collection(_chats)
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await _user
          .doc(auth.currentUser!.uid)
          .collection(_chats)
          .doc(recieverUid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Groups>> getGroup() {
    return _group
        .where('membersUid', arrayContains: auth.currentUser!.uid)
        .snapshots()
        .map((event) {
      List<Groups> list = [];
      for (var doc in event.docs) {
        list.add(Groups.fromMap(doc.data() as Map<String, dynamic>));
      }
      return list;
    });
  }
}
