import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<FilePickerResult?> pickImage() async {
  return await FilePicker.platform.pickFiles(type: FileType.image);
}

Future<FilePickerResult?> pickVideo() async {
  return await FilePicker.platform.pickFiles(type: FileType.video);
}
