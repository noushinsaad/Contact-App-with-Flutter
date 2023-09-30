import 'dart:io';

class Contact {
  //Databse id/key
  int? id;

  String name;
  String email;
  String phoneNumber;
  //not all phone numbers are valid mathemetical numbers
  bool isFavorite;
  File? imageFile;
  //Constructor with optional named paramaeters
  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite, // ? 1 : 0,
      'imageFilePath': imageFile?.path
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'], //== 1 ? true : false,
      imageFile:
          map['imageFilePath'] != null ? File(map['imageFilePath']) : null,
    );
  }
}
