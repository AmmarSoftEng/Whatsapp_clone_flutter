// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widget/loder.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';
import 'package:whatsapp/features/status/screen/status_content.dart';
import 'package:whatsapp/features/status/screen/status_s.dart';

class StatusScreen extends ConsumerWidget {
  StatusScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyStatus(),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Recent Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        statusget(),
      ],
    );
  }
}

class statusget extends ConsumerWidget {
  const statusget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.watch(statusControllerProvider).fechStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loder();
          }
          return SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var statusData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            StatusS.routeName,
                            arguments: statusData,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              statusData.username,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                statusData.profilePic,
                              ),
                              radius: 30,
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: dividerColor, indent: 85),
                    ],
                  );
                }),
          );
        });
  }
}
