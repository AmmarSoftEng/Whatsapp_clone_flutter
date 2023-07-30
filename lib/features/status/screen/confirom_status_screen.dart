// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';

class ConformStats extends ConsumerWidget {
  static const String routeName = '/status-screen';
  File file;
  ConformStats({
    required this.file,
  });

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).addstatus(context, file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: () => addStatus(context, ref),
        backgroundColor: tabColor,
      ),
    );
  }
}
