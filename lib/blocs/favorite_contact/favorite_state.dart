

import 'package:contactsapp/model/contact.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteContactsState extends Equatable{
  const FavoriteContactsState();

  @override
  List<Object> get props => [];
}

class FavoriteContactsLoadInProgress extends FavoriteContactsState{}

class FavoriteContactsLoadSuccess extends FavoriteContactsState{
  final List<Contact> contacts;

  const FavoriteContactsLoadSuccess([this.contacts = const[]]);

  @override
  List<Object> get props => [contacts];

  @override
  String toString() => 'FavoriteContactsLoadSuccess { contacts: $contacts }';
}

class FavoriteContactsLoadFailure extends FavoriteContactsState{}