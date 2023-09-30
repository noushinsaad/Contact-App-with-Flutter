//import 'dart:js_interop_unsafe';

// ignore_for_file: deprecated_member_use

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:contacts_app/data/contact.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contactIndex,
  }) : super(key: key);

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {
              model.deleteContact(displayedContact);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: BehindMotion(),
        children: <Widget>[
          SlidableAction(
              onPressed: (context) {
                _callPhoneNumber(
                  context,
                  displayedContact.phoneNumber,
                );
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.phone,
              label: 'Call'),
          SlidableAction(
              onPressed: (context) {
                _writeEmail(
                  context,
                  displayedContact.email,
                );
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.email,
              label: 'Email'),
        ],
      ),
      child: _buildContent(
        context,
        displayedContact,
        model,
      ),
    );
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    final url = 'tel:$number';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot make a call'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(BuildContext context, String emailAddress) async {
    final url = 'mailto:$emailAddress';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot write an email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    ContactsModel model,
  ) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        leading: _buildCircleAvatar(displayedContact),
        trailing: IconButton(
          icon: Icon(
              displayedContact.isFavorite ? Icons.star : Icons.star_border),
          color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
          onPressed: () {
            model.changeFavoriteStatus(displayedContact);
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactEditPage(
                editedContact: displayedContact,
                //editedContactIndex: contactIndex,
              ),
            ),
          );
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(
        child: _buildCircleAvatarContent(displayedContact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imageFile == null) {
      return Text(
        displayedContact.name[0],
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.imageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
