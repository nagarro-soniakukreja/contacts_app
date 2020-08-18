
class ContactEntity{
  var _id;
  final _name;
  final _mobile;
  final _landLine;
  final _favorite;
  final _image;

  ContactEntity(this._name, this._mobile, this._landLine, this._favorite, this._image);
  ContactEntity.withId(this._id, this._name, this._mobile, this._landLine, this._favorite, this._image);

  int get id => _id;
  String get name => _name;
  int get mobile => _mobile;
  int get landLine => _landLine;
  int get favorite => _favorite;
  String get image => _image;

/*
  set mobile(int value) {
    _mobile = value;
  }

  set landLine(int value) {
    _landLine = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }

  set favorite(int value) {
    _favorite = value;
  }

  set image(String value) {
    _image = value;
  }*/

  Map<String, dynamic> getMap() {
    return {
      'id' : _id,
      'name' : _name,
      'mobile' : mobile,
      'landline' : _landLine,
      'favorite' : _favorite,
      'image' : _image,

    };
  }

/*  ContactEntity.fromObject(dynamic obj){
    this._id = obj["id"];
    this._name = obj["name"];
    this._mobile = obj["mobile"];
    this._landLine = obj["landline"];
    this._favorite = obj["favorite"];
    this._image = obj["image"];
  }*/

}