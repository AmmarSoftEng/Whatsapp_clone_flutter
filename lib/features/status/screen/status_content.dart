import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/status/controller/status_controller.dart';
import 'package:whatsapp/features/status/screen/status_s.dart';
import 'package:whatsapp/model/status_modle.dart';

class MyStatus extends ConsumerWidget {
  MyStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
        future: ref.watch(statusControllerProvider).getMyStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var ss = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              StatusS.routeName,
                              arguments: ss,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                "My Status",
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  ss.profilePic,
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
            ),
          );
        });
  }
}
