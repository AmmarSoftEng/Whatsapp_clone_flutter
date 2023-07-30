// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/constants/firebase_constants.dart';

final commonFirebaseStorage =
    Provider((ref) => StoreFile(firebaseStorage: ref.read(storageProvider)));

class StoreFile {
  // FirebaseStorage storage;
  // StoreFile({
  //   required this.storage,
  // });
  // Future storreFile(String uid,File profileImage)async{
  //  final uploadImage = storage.ref().child("User/profile$uid").putFile(profileImage);
  //  final snapshot= await uploadImage;
  // snapshot.ref.getDownloadURL();
  // }

  final FirebaseStorage _storage;
  StoreFile({required FirebaseStorage firebaseStorage})
      : _storage = firebaseStorage;

  Future<String> storeFile(
      {required String path,
      required File file,
      required BuildContext context}) async {
    final snapshort = await _storage.ref().child(path).putFile(file);
    return await snapshort.ref.getDownloadURL();
  }
}
