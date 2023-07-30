// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/fierbase_store.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/model/status_modle.dart';
import 'package:whatsapp/model/user_model.dart';

import '../../../common/constants/firebase_constants.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final Ref ref;

  StatusRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });
  CollectionReference get _user =>
      firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _status =>
      firestore.collection(FirebaseConstants.statusCollection);

  void uploadStatus(
    BuildContext context,
    String userName,
    File statusImage,
    String phoneNumber,
    String profilePic,
  ) async {
    try {
      var statusId = Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref.read(commonFirebaseStorage).storeFile(
          path: '/status/$statusId$uid', file: statusImage, context: context);

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFierbase = await _user
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (userDataFierbase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(
              userDataFierbase.docs[0].data() as Map<String, dynamic>);
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusmagesUrl = [];

      var statusSnapShort =
          await _status.where('uid', isEqualTo: auth.currentUser!.uid).get();

      if (statusSnapShort.docs.isNotEmpty) {
        Status status = Status.fromMap(
            statusSnapShort.docs[0].data() as Map<String, dynamic>);
        statusmagesUrl = status.photoUrl;
        statusmagesUrl.add(imageUrl);
        _status
            .doc(statusSnapShort.docs[0].id)
            .update({'photoUrl': statusmagesUrl});
      } else {
        statusmagesUrl = [imageUrl];
      }
      Status status = Status(
          uid: uid,
          username: userName,
          phoneNumber: phoneNumber,
          photoUrl: statusmagesUrl,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: uidWhoCanSee);
      await _status.doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];

    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshort = await _status
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .where('createdAt',
                isGreaterThan:
                    DateTime.now().subtract(Duration(hours: 24)).microsecond)
            .get();

        for (var tempdata in statusesSnapshort.docs) {
          Status tempStatus =
              Status.fromMap(tempdata.data() as Map<String, dynamic>);
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }

  Future<List<Status>> getMyStatus(BuildContext context) async {
    List<Status> s = [];

    var datt =
        await _status.where('uid', isEqualTo: auth.currentUser!.uid).get();

    if (datt.docs.isNotEmpty) {
      var suv = Status.fromMap(datt.docs[0].data() as Map<String, dynamic>);
      s.add(suv);
    }

    return s;
  }
}
