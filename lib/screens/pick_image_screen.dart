

import 'dart:io';
import 'dart:ui';

import 'package:contactsapp/provider/pictures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:contactsapp/model/picture.dart';

class PickImageScreen extends StatefulWidget{
  final int id;

  const PickImageScreen({Key key,
    @required this.id}): super(key: key);

  @override
  State<StatefulWidget> createState() => PickImageScreenState();

}

class PickImageScreenState extends State<PickImageScreen>{

  File _takenImage;
  Future<void> _pickImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _takenImage = imageFile;
    });
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    var _imageToStore = Picture(picName: savedImage);
    _storeImage() {
      Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore);
    }

    _storeImage();

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton.icon(
          icon: Icon(
            Icons.photo_camera,
            size: 100,
          ),
          label: Text(''),
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
        ),
      ),
    );
  }

}