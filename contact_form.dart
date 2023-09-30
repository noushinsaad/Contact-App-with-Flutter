// ignore_for_file: unused_element

import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editedContact;
  //final int? editedContactIndex;

  ContactForm({
    Key? key,
    this.editedContact,
    //this.editedContactIndex,
  }) : super(key: key);

  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  //key allow us to acess widgets from a different place in the code
  //They are something like View iDs if you are familiar with android development
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _phoneNumber;
  File? _contactImageFile;

  // ignore: unnecessary_null_comparison
  bool get isEditMode => widget.editedContact != null;
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.editedContact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          SizedBox(height: 10),
          _contactPicture(),
          SizedBox(height: 10),
          TextFormField(
            onSaved: (value) => _name = value!,
            validator: (value) {
              return _namevalidation(value);
            },
            initialValue: widget.editedContact?.name,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            onSaved: (value) => _email = value!,
            validator: (value) {
              return _emailvalidation(value);
            },
            initialValue: widget.editedContact?.email,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            onSaved: (value) => _phoneNumber = value!,
            validator: (value) {
              return _phoneNumbervalidation(value);
            },
            initialValue: widget.editedContact?.phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _onSaveButtonPressed();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('SAVE CONTACT'),
                Icon(
                  Icons.person,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _namevalidation(value) {
    if (value == null || value.isEmpty) {
      return 'Enter a Name';
    }
    return null;
  }

  String? _emailvalidation(value) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    if (value == null || value.isEmpty) {
      return 'Enter an Email adress';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid Email adress';
    }
    return null;
  }

  String? _phoneNumbervalidation(value) {
    final phoneRegex = RegExp(r"^([01]|\+88)?\d{5}");
    if (value == null || value.isEmpty) {
      return 'Enter a Phone Number';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid Phone Number';
    }
    return null;
  }

  void _onSaveButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newContact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavorite: widget.editedContact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );
      if (isEditMode) {
        newContact.id = widget.editedContact!.id;
        ScopedModel.of<ContactsModel>(context).updateContact(
          newContact,
          //widget.editedContactIndex,
        );
      } else {
        ScopedModel.of<ContactsModel>(context).addContact(newContact);
      }
      Navigator.of(context).pop();
    }
  }

  Widget _contactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleAvatarContent(halfScreenDiameter),
        ),
      ),
    );
  }

  Widget _buildCircleAvatarContent(double halfScreenDiameter) {
    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenDiameter / 2,
      );
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0],
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            _contactImageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  void _onContactPictureTapped() async {
    final XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final File? imagefile = File(imageFile!.path);
    setState(
      () {
        _contactImageFile = imagefile;
      },
    );
  }
}
