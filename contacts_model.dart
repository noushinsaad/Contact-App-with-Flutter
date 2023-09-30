import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/contact_dao.dart';
//import 'package:faker/faker.dart' as faker;
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  final ContactDao _contactDao = ContactDao();

  late List<Contact> _contacts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  //get only property
  List<Contact> get contacts => _contacts;

  Future loadContacts() async {
    _isLoading = true;
    notifyListeners();

    _contacts = await _contactDao.getAllSortedOrder();

    _isLoading = false;
    notifyListeners();
  }

  Future addContact(Contact contact) async {
    //print(_contacts.length);
    //_contacts.add(contact);
    //print(_contacts.length);
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  }

  Future updateContact(Contact contact) async {
    //_contacts[contactIndex] = contact;
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

  Future deleteContact(Contact contact) async {
    //_contacts.removeAt(index);
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    _contacts = await _contactDao.getAllSortedOrder();
    notifyListeners();
  }

  /*void _sortContacts() {
    _contacts.sort((a, b) {
      int comparisonResult;

      //Primarily sorting based on whether otr not the contact is favorite
      comparisonResult = _compareBasedOnfavoriteStatus(a, b);

      //if the favorite satus of two contact is identical
      //secondary, alphabetical sorting kicks in
      if (comparisonResult == 0) {
        comparisonResult = _compareAlphabetically(a, b);
      }
      return comparisonResult;
    });
  }

  int _compareBasedOnfavoriteStatus(Contact a, Contact b) {
    if (a.isFavorite) {
      //contactOne will be before conntactTwo
      return -1;
    } else if (b.isFavorite) {
      //contactOne will be after contactTwo
      return 1;
    } else {
      //the position doesn't changed
      return 0;
    }
  }

  int _compareAlphabetically(Contact a, Contact b) {
    return a.name.compareTo(b.name);
  }*/
}
