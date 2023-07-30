import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/common/widget/error.dart';
import 'package:whatsapp/features/auth/screen/login_screen.dart';
import 'package:whatsapp/features/auth/screen/otp_screen.dart';
import 'package:whatsapp/features/auth/screen/user_info_screen.dart';
import 'package:whatsapp/features/chat/screen/mobile_chat_screen.dart';
import 'package:whatsapp/features/group/screen/screen.dart';
import 'package:whatsapp/features/status/screen/confirom_status_screen.dart';
import 'package:whatsapp/features/status/screen/status_s.dart';
import 'package:whatsapp/model/status_modle.dart';

import 'features/contacts/screen/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LogingScreen.routeName:
      return MaterialPageRoute(builder: (context) => LogingScreen());

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(verificationId: verificationId));

    case SelectContactsScreen.routeName:
      // final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => SelectContactsScreen());

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) => UserInformationScreen());

    case MobileChatScreen.routeName:
      final userData = settings.arguments as Map<String, dynamic>;
      String name = userData['name'];
      String uid = userData['uid'];
      bool isGroup = userData['isGroup'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                isGroup: isGroup,
              ));
    case ConformStats.routeName:
      final statusImage = settings.arguments as File;

      return MaterialPageRoute(
          builder: (context) => ConformStats(
                file: statusImage,
              ));
    case StatusS.routeName:
      final status = settings.arguments as Status;

      return MaterialPageRoute(
          builder: (context) => StatusS(
                status: status,
              ));
    case GroupChart.routeName:
      return MaterialPageRoute(builder: (context) => GroupChart());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
