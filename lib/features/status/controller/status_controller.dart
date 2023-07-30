import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_contriller.dart';
import 'package:whatsapp/features/status/repository/status_repository.dart';
import 'package:whatsapp/model/status_modle.dart';

final statusControllerProvider = Provider((ref) => StatusController(
    statusRepository: ref.read(statusRepositoryProvider), ref: ref));

class StatusController {
  final StatusRepository statusRepository;
  final Ref ref;

  StatusController({required this.statusRepository, required this.ref});

  void addstatus(BuildContext context, File statusImage) {
    ref.read(userDataAuthProvider).whenData((value) =>
        statusRepository.uploadStatus(context, value!.name, statusImage,
            value.phoneNumber, value.profilePic));
  }

  Future<List<Status>> fechStatus(BuildContext context) async {
    return await statusRepository.getStatus(context);
  }

  Future<List<Status>> getMyStatus(BuildContext context) async {
    return await statusRepository.getMyStatus(context);
  }
}
