// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/contacts/repository/contacts_repository.dart';

final contactControllerProvider = Provider((ref) =>
    ContactsController(contactRepository: ref.read(contactRepositoryProvider)));

final getContactProvider =
    FutureProvider((ref) => ref.read(contactControllerProvider).getContact());

// final selectContact=StreamProvider.family((ref,)=> ref.read(contactControllerProvider).selectContect(context, selectedcontact));

class ContactsController {
  ContactRepository contactRepository;
  ContactsController({
    required this.contactRepository,
  });

  Future<List<Contact>> getContact() async {
    return contactRepository.getContacts();
  }

  void selectContect(Contact selectedcontact, BuildContext context) {
    return contactRepository.selectContect(selectedcontact, context);
  }
}
