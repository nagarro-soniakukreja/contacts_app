import 'package:contactsapp/model/contact.dart';
import 'package:contactsapp/model/contact_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../contacts.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository contactsRepository;

  ContactsBloc({@required this.contactsRepository})
      : super(ContactsLoadInProgress());

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is ContactsRequested) {
      yield* _mapContactsLoadedToState(event);
    } else if (event is ContactAdded) {
      yield* _mapContactAddedToState(event);
    } else if (event is ContactUpdated) {
      yield* _mapContactUpdatedToState(event);
    } else if (event is ContactDeleted) {
      yield* _mapContactDeletedToState(event);
    }
  }

  Stream<ContactsState> _mapContactsLoadedToState(ContactsEvent event) async* {
    yield ContactsLoadInProgress();
    try {
      var list = List<Contact>();
      final contacts = await this.contactsRepository.getAllContacts();
      contacts.forEach((element) {
        list.add(Contact.fromEntity(element));
      });
      yield ContactsLoadSuccess(list
//        contacts.map(Contact.fromEntity).toList(),
          );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactAddedToState(ContactAdded event) async* {
    if (state is ContactsLoadSuccess) {
      final List<Contact> updatedContacts =
          List.from((state as ContactsLoadSuccess).contacts)
            ..add(event.contact);
      yield ContactsLoadSuccess(updatedContacts);
          await contactsRepository.addNewContact(event.contact.toEntity());
    }
  }

  Stream<ContactsState> _mapContactUpdatedToState(ContactUpdated event) async* {

    if (state is ContactsLoadSuccess) {
      final List<Contact> updatedContacts = (state as ContactsLoadSuccess)
          .contacts.map((contact) {
        return contact.id == event.contact.id ? event.contact : contact;
      }).toList();
      await contactsRepository.updateContact(event.contact.toEntity());
      yield ContactsLoadSuccess(updatedContacts);
    }
  }

  Stream<ContactsState> _mapContactDeletedToState(ContactDeleted event) async* {
    if (state is ContactsLoadSuccess) {
      final updatedContacts = (state as ContactsLoadSuccess)
          .contacts
          .where((contact) => contact.id != event.contact.id)
          .toList();
      await contactsRepository.deleteContact(event.contact.toEntity());
      yield ContactsLoadSuccess(updatedContacts);
    }
  }
}
