// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/constants/firebase_constants.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/features/chat/screen/mobile_chat_screen.dart';

final contactRepositoryProvider = Provider((ref) {
  return ContactRepository(firebaseFirestore: ref.read(firestoreProvider));
});

class ContactRepository {
  FirebaseFirestore firebaseFirestore;
  ContactRepository({
    required this.firebaseFirestore,
  });

  CollectionReference get _user =>
      firebaseFirestore.collection(FirebaseConstants.usersCollection);

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContect(Contact selectedcontact, BuildContext context) async {
    var selectedNum = selectedcontact.phones[0].number.replaceAll(' ', '');
    bool isfound = false;
    try {
      var res =
          await _user.where('phoneNumber', isEqualTo: selectedNum).get().then(
        (res) {
          isfound = true;
          var a = res.docs.first;
          var user = UserModel.fromMap(a.data() as Map<String, dynamic>);

          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': user.name, 'uid': user.uid});
        },
        onError: (e) => print("Error completing: $e"),
      );
      if (isfound == false) {
        showSnackBar(context: context, content: "not Founds");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
