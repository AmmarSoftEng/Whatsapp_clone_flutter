// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/constants/firebase_constants.dart';
import 'package:whatsapp/common/repository/fierbase_store.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/model/group.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  Ref ref;
  GroupRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });
  CollectionReference get _user =>
      firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _group =>
      firestore.collection(FirebaseConstants.groupCollection);

  void creatGroup(BuildContext context, File image, List<Contact> listContact,
      String groupName) async {
    try {
      List<String> uids = [];

      for (int i = 0; i < listContact.length; i++) {
        var userSnapshort = await _user
            .where(
              'phoneNumber',
              isEqualTo: listContact[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();

        if (userSnapshort.docs.isNotEmpty && userSnapshort.docs[0].exists) {
          uids.add(userSnapshort.docs[0]['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String fileUrl = await ref
          .read(commonFirebaseStorage)
          .storeFile(path: '/groupPic/$groupId', file: image, context: context);
      Groups groupModle = Groups(
          senderId: auth.currentUser!.uid,
          name: groupName,
          groupId: groupId,
          lastMessage: '',
          groupPic: fileUrl,
          membersUid: [auth.currentUser!.uid, ...uids],
          timeSent: DateTime.now());
      _group.doc(groupId).set(groupModle.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
