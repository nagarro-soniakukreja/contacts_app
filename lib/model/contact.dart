
import 'package:contactsapp/model/contact_entity.dart';
import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  int id;
  final String name;
  final int mobile;
  final int landline;
  final int favorite;
  final String image;

  Contact(
      this.id,
      this.name, this.mobile,
      this.landline ,
  this.favorite, this.image);

  Contact copyWith({String name, int mobile, int landline, int favorite, String image}) {
    return Contact(
      id ?? this.id,
      name ?? this.name,
      mobile ?? this.mobile,
      landline ?? this.landline,
      favorite ?? this.favorite,
      image ?? this.image,
    );
  }

  @override
  List<Object> get props => [id,name, mobile, landline, favorite];

  @override
  String toString() {
    return 'Contact { id: $id, name: $name, mobile: $mobile, landline: $landline, favorite: $favorite }';
  }

  ContactEntity toEntity() {
    return ContactEntity.withId(id,name, mobile, landline, favorite, image);
  }

  static Contact fromEntity(ContactEntity entity) {
    return Contact(
      entity.id,
      entity.name,
      entity.mobile,
      entity.landLine,
      entity.favorite,
      entity.image,
    );
  }
}