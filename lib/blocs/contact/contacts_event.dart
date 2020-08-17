

import 'package:contactsapp/model/contact.dart';
import 'package:equatable/equatable.dart';


abstract class ContactsEvent extends Equatable{
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class ContactsRequested extends ContactsEvent {}

//class ContactFavoriteRequested extends ContactsEvent{}

class ContactAdded extends ContactsEvent{
  final Contact contact;

  const ContactAdded(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactAdded { contact: $contact }';
}

class ContactUpdated extends ContactsEvent{
  final Contact contact;

  const ContactUpdated(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactUpdated { contact: $contact }';
}

class ContactDeleted extends ContactsEvent{
  final Contact contact;

  const ContactDeleted(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactDeleted { contact: $contact }';
}