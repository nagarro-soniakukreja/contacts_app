
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:contactsapp/blocs/contacts.dart';
import 'package:contactsapp/model/contact.dart';
import 'package:contactsapp/screens/take_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';


class AddNewContactScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AddNewContactScreenState();

}

class AddNewContactScreenState extends State<AddNewContactScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController landlineController = TextEditingController();
  bool isFav = false;
  File _takenImage;
  Uint8List _bytesImage;
  String  contactImage;

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Add New Contact'),
          ),
          body: getBody(),
        );
      },
    );

  }

  getBody() {
    return Container(
      child: ListView( // resolve the overflow bottom issue
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
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
                              ):Icon(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
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
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
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
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Icon(
                        isFav? Icons.favorite: Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text('Save'),
                      onPressed: (){
                        addContact();
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void addContact() {
    var contact = Contact(null,nameController.text,
        mobileController.text.toString().isEmpty?0:int.parse(mobileController.text.toString()),
        landlineController.text.toString().isEmpty?0:int.parse(landlineController.text.toString()),
        isFav?1:0, contactImage);
    BlocProvider.of<ContactsBloc>(context).add(ContactAdded(contact));
    Navigator.pop(context, contact);
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

  void _dismissDialog() {
    Navigator.pop(context);
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
}

