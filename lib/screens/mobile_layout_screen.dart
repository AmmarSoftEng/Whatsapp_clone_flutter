import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/controller/auth_contriller.dart';
import 'package:whatsapp/features/contacts/screen/select_contact_screen.dart';
import 'package:whatsapp/features/chat/widget/contacts_list.dart';
import 'package:whatsapp/features/group/screen/screen.dart';
import 'package:whatsapp/features/status/screen/confirom_status_screen.dart';
import 'package:whatsapp/features/status/screen/status_content.dart';
import 'package:whatsapp/features/status/screen/status_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.watch(authControllerProvider.notifier).setOnline(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.watch(authControllerProvider.notifier).setOnline(false);
        break;
    }
  }

  void navigateToSlectContactScreen(BuildContext context) {
    Navigator.pushNamed(context, SelectContactsScreen.routeName);
  }

  void navigateToConfiromStatusScreen(BuildContext context, File file) {
    Navigator.pushNamed(context, ConformStats.routeName, arguments: file);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (contex) => [
                PopupMenuItem(
                  child: Text('Create group'),
                  onTap: () => Future(
                      () => Navigator.pushNamed(context, GroupChart.routeName)),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: controller,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: controller, children: [
          ContactsList(),
          StatusScreen(),
          MyStatus(),
          // Tab(
          //   text: 'CALLS',
          // ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (controller.index == 0) {
              navigateToSlectContactScreen(context);
            } else {
              File? file;
              var result = await pickImage();
              if (result != null) {
                file = File(result.files.first.path!);
                navigateToConfiromStatusScreen(context, file);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
