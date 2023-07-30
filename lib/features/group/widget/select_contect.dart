import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/widget/error.dart';
import 'package:whatsapp/common/widget/loder.dart';
import 'package:whatsapp/features/contacts/controller/contacts_controller.dart';

final selectContectee = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectContactIndex = [];

  void selectContect(int index, Contact contact) {
    if (selectContactIndex.contains(index)) {
      selectContactIndex.remove(index);
    } else {
      selectContactIndex.add(index);
    }
    setState(() {});
    ref.read(selectContectee.notifier).update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactProvider).when(
          data: (contactList) {
            return Expanded(
              child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (contex, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () {
                        selectContect(index, contact);
                      },
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: selectContactIndex.contains(index)
                            ? Icon(Icons.done)
                            : Icon(Icons.add_box),
                      ),
                    );
                  }),
            );
          },
          error: (error, stracktrace) => ErrorScreen(error: error.toString()),
          loading: () => Loder(),
        );
  }
}
