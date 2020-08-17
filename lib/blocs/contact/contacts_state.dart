

import 'package:contactsapp/model/contact.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable{
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsLoadInProgress extends ContactsState{}

class ContactsLoadSuccess extends ContactsState{
  final List<Contact> contacts;

  const ContactsLoadSuccess([this.contacts = const[]]);

  @override
  List<Object> get props => [contacts];

  @override
  String toString() => 'ContactsLoadSuccess { contacts: $contacts }';
}

class ContactsLoadFailure extends ContactsState{}