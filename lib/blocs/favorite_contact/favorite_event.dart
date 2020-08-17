

import 'package:contactsapp/model/contact.dart';
import 'package:equatable/equatable.dart';


abstract class FavoriteContactsEvent extends Equatable{
  const FavoriteContactsEvent();

  @override
  List<Object> get props => [];
}

class FavoriteContactRequested extends FavoriteContactsEvent{}

class FavoriteContactUpdated extends FavoriteContactsEvent{
  final Contact contact;

  const FavoriteContactUpdated(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactUpdated { contact: $contact }';
}

class FavoriteContactDeleted extends FavoriteContactsEvent{
  final Contact contact;

  const FavoriteContactDeleted(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactDeleted { contact: $contact }';
}