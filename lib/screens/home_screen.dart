import 'package:contactsapp/blocs/navigation_drawer_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_new_contact_screen.dart';
import 'contact_list_screen.dart';
import 'favorite_contact_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(title!= null?title:"Contact List")
      ),
      drawer: getDrawer(),
      body: StreamBuilder(
        stream: navigationBloc.getNavigation,
        initialData: navigationBloc.navigationProvider.currentNavigation,
        builder: (context, snapshot) {
          if (navigationBloc.navigationProvider.currentNavigation ==
              "Favorite Contacts") {
            return FavoriteContactListScreen();
          } else if (navigationBloc.navigationProvider.currentNavigation ==
              "Add New Contact") {
            return AddNewContactScreen();
          } else {
            return ContactListScreen();
          }
        }, // access the data in our Stream here
      ),
    );
  }

  getDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 2 / 3,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Contact App"),
            ),
            ListTile(
              title: Text("Contact List"),
              onTap: () {
                setState(() {
                  title = "Contact List";
                });
                Navigator.of(context).pop(context);
                navigationBloc.updateNavigation("Contact List");
              },
            ),
            ListTile(
              title: Text("Favorite Contacts"),
              onTap: () {
                setState(() {
                  title = "Favorite Contact";
                });
                Navigator.of(context).pop(context);
                navigationBloc.updateNavigation("Favorite Contacts");
              },
            ),
            ListTile(
              title: Text("Add New Contact"),
              onTap: () {
                Navigator.of(context).pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewContactScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

//  void navigateToScreen(int i) {
//    switch(i) {
//      case 1:
//        Navigator.push(context, MaterialPageRoute<FavoriteContactListScreen>(builder: (context) => FavoriteContactListScreen()));
//        break;
//      case 2:
//        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewContactScreen()));
//        break;
//      default:
//        Navigator.push(context, MaterialPageRoute(builder: (context) => ContactListScreen()));
//    }
//  }

}
