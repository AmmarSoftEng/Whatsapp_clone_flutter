// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enum/enum.dart';

class ReplayProvider {
  final String message;
  final MessageEnum type;
  final bool isMe;
  ReplayProvider({
    required this.message,
    required this.type,
    required this.isMe,
  });
}

final messageReplyProvider = StateProvider<ReplayProvider?>((ref) => null);
