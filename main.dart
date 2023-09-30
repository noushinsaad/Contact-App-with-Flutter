//import 'package:contacts_app/ui/contact/contact_ceate_page.dart';
import 'package:contacts_app/ui/contacts_list/contacts_list_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Soped model widget will make sure that we can access the ContactModel
    //anywhere from the widget tree. This is because of Flutter's
    //Inherited Widget which is biy advanced to briefly explain, but if
    //you have the drive to learn it, ofiicial flutter docs can help you.
    return ScopedModel(
      model: ContactsModel()..loadContacts(),
      child: MaterialApp(
        title: 'Contacts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: ContactsListPage(),
        home: ContactsListPage(),
      ),
    );
  }
}
