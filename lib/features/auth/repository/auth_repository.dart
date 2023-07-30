import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/constants/firebase_constants.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/screen/otp_screen.dart';
import 'package:whatsapp/features/auth/screen/user_info_screen.dart';
import 'package:whatsapp/model/group.dart';
import 'package:whatsapp/model/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance, firestore: ref.read(firestoreProvider));
});

class AuthRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  CollectionReference get _user =>
      firestore.collection(FirebaseConstants.usersCollection);

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  // Future saveUserInfo(BuildContext context, File profile, String name) async {
  //   try {} on FirebaseException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }

  Future saveUserInfo(UserModel user) async {
    try {
      await _user.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<UserModel> getUser(String uid) async {
    UserModel? userModel;
    var userData = await _user.doc(uid).get();
    if (userData.data() != null) {
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
    }
    return userModel!;
  }

  Stream<UserModel> getUserInfo(String uid) {
    return _user.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<Groups> getGroupData(String groupUid) {
    return _user
        .doc(groupUid)
        .snapshots()
        .map((event) => Groups.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData = await _user.doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()! as Map<String, dynamic>);
    }
    return user;
  }

  void setOnline(bool isOnline) async {
    await _user.doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
