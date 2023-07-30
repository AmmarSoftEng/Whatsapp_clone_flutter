import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/group/controller/group_controller.dart';
import 'package:whatsapp/features/group/widget/select_contect.dart';

class GroupChart extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const GroupChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupChartState();
}

class _GroupChartState extends ConsumerState<GroupChart> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        image = File(result.files.first.path!);
      });
    }
  }

  void creatGroup() {
    if (image != null && groupNameController.text.trim().isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(context,
          groupNameController.text.trim(), image!, ref.read(selectContectee));
      ref.read(selectContectee.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                        ),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(
                          image!,
                        ),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: creatGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
    ;
  }
}
