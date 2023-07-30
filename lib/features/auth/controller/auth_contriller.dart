// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/constants/firebase_constants.dart';
import 'package:whatsapp/common/repository/fierbase_store.dart';

import 'package:whatsapp/features/auth/repository/auth_repository.dart';
import 'package:whatsapp/model/group.dart';
import 'package:whatsapp/model/user_model.dart';
import 'package:whatsapp/screens/mobile_layout_screen.dart';

import '../../../common/utils/utils.dart';

final authControllerProvider = StateNotifierProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
      authRepository: authRepository, auth: ref.read(authProvider), ref: ref);
});

final userProvider = FutureProvider(
    (ref) => ref.watch(authControllerProvider.notifier).getUser());

final getUserModleProvider = StreamProvider.family((ref, String uid) {
  return ref.read(authControllerProvider.notifier).getUserData(uid);
});

final uProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserDataa();
});

class AuthController extends StateNotifier {
  AuthRepository authRepository;
  FirebaseAuth auth;
  Ref ref;
  AuthController({
    required this.authRepository,
    required this.auth,
    required this.ref,
  }) : super(null);

  void phoneSignIn(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserInfo(BuildContext context, File? profile, String name) async {
    try {
      String pic;
      pic =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profile != null) {
        pic = await ref.read(commonFirebaseStorage).storeFile(
            path: 'profilePic/${auth.currentUser!.uid}',
            file: profile,
            context: context);
      }

      UserModel user = UserModel(
          name: name,
          uid: auth.currentUser!.uid,
          profilePic: pic,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      final res = await authRepository.saveUserInfo(user);
      if (res != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
            (route) => false);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<UserModel?> getUser() async {
    UserModel? userModel;
    userModel = await authRepository.getUser(auth.currentUser!.uid);
    return userModel;
  }

  Stream<UserModel> getUserData(String uid) {
    return authRepository.getUserInfo(uid);
  }

  Stream<Groups> getGroupData(String groupUid) {
    return authRepository.getGroupData(groupUid);
  }

  Future<UserModel?> getUserDataa() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void setOnline(bool isOnline) {
    authRepository.setOnline(isOnline);
  }
}
