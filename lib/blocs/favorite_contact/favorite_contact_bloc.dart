import 'dart:async';

import 'package:contactsapp/blocs/favorite_contact/favorite_event.dart';
import 'package:contactsapp/blocs/favorite_contact/favorite_state.dart';
import 'package:contactsapp/model/contact.dart';
import 'package:contactsapp/model/contact_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class FavoriteContactsBloc extends Bloc<FavoriteContactsEvent, FavoriteContactsState> {
  ContactsRepository contactsRepository;

  FavoriteContactsBloc({@required this.contactsRepository})
      : super(FavoriteContactsLoadInProgress(),);

  @override
  Stream<FavoriteContactsState> mapEventToState(FavoriteContactsEvent event) async* {
    if (event is FavoriteContactRequested) {
      yield* _mapContactsFavoriteLoadedToState(event);
    }
  }

  Stream<FavoriteContactsState> _mapContactsFavoriteLoadedToState(
      FavoriteContactRequested event) async* {
    yield FavoriteContactsLoadInProgress();
    try {
      var list = List<Contact>();
      final contacts = await this.contactsRepository.getAllFavoriteContacts();
      contacts.forEach((element) {
        list.add(Contact.fromEntity(element));
      });
      yield FavoriteContactsLoadSuccess(
        list,
      );
    } catch (_) {
      yield FavoriteContactsLoadFailure();
    }
  }
}
