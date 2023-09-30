//import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_ceate_page.dart';
import 'package:contacts_app/ui/contacts_list/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';

class ContactsListPage extends StatefulWidget {
  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  //runs when the state changes.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        //runs when notifylisteners() is called from the model
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: model.contacts.length,
              // Runs and builds every single list item
              itemBuilder: (context, index) {
                return ContactTile(
                  contactIndex: index,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ContactCreatePage()),
          );
        },
      ),
    );
  }
}
