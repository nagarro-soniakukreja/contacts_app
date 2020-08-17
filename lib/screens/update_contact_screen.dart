import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:contactsapp/blocs/contacts.dart';
import 'package:contactsapp/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'take_picture_screen.dart';

class UpdateContactScreen extends StatefulWidget {
  Contact contact;

  UpdateContactScreen(this.contact, {Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateContactScreenState(contact);
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  Contact contact;

  _UpdateContactScreenState(this.contact);

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController landlineController = TextEditingController();
  bool isFav = false;
  String favStr;
  File _takenImage;
  String contactImage;
  Uint8List _bytesImage;

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
    encodeImagefile(imageFile);

  }

  void encodeImagefile(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    print(imageBytes);
    contactImage = base64Encode(imageBytes);
    print('string is');
    print(contactImage);
    print("You selected gallery image : " + imageFile.path);
    _bytesImage = Base64Decoder().convert(contactImage);
  }

  void getData() {
    if (contact != null) {
      nameController.text = contact.name;
      mobileController.text = contact.mobile.toString();
      landlineController.text = contact.landline.toString();
      isFav = contact.favorite != 0 ? true : false;
      contactImage = contact.image;
      _bytesImage = contactImage!=null?Base64Decoder().convert(contactImage):null;
    }
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Update Contact'),
        ),
        body: getBody(),
      );
    });
  }

  getBody() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Align(
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        child: ClipRRect(
                            borderRadius:BorderRadius.circular(40),
                            child:_bytesImage!=null?Image.memory(_bytesImage,
                                fit: BoxFit.cover,width: 77.0, height: 77.0,
                                colorBlendMode: BlendMode.clear
                            ): Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(top: 63.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(Icons.camera_alt,
                            color: Colors.blue,),
                        ),
                      ),
                      onTap: (){
                        openImageOptions();
                      },
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),

                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: landlineController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Landline Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        isFav = !isFav;
                      });
                    },
                  )),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text('Update'),
                        onPressed: () {
                          updateContact();
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text('Delete'),
                        onPressed: () {
                          deleteContact();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  openImageOptions() {
    var alert =  AlertDialog(
      title: Text('Choose the following:'),
      content: Wrap(
        children: [
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Text('Camera Roll'),
                    onTap: () {
                      _pickImage();
                      _dismissDialog();
                    },
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Text('Take a picture'),
                    onTap: () {
                      openCamera();
                      _dismissDialog();
                    },
                  )
              ),
            ],
          ),
        ],
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void openCamera() async{
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> TakePictureScreen(camera: firstCamera)));
    if (result != null) {
      setState(() {
        _takenImage = File(result);
        encodeImagefile(_takenImage);
      });
    }

  }

  void updateContact() {
    BlocProvider.of<ContactsBloc>(context).add(ContactUpdated(contact.copyWith(name: nameController.text,
        mobile: int.parse(mobileController.text.toString()),
        landline: int.parse(landlineController.text.toString()),
        favorite: isFav?1:0,
        image:contactImage)));
    Navigator.pop(context, "Contact Updated!");
  }

  void deleteContact() {
    BlocProvider.of<ContactsBloc>(context).add(ContactDeleted(contact));
    Navigator.pop(context, "Contact Deleted!");
  }

}
