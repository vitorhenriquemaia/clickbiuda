import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  String _id;
  String _state;
  String _category;
  String _places;
  String _size;
  String _title;
  String _vendor;
  String _price;
  String _phone;
  String _whatsapp;
  String _description;
  List<String> _photos;

  Product();

  Product.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.state = documentSnapshot["state"];
    this.category = documentSnapshot["category"];
    this.places = documentSnapshot["places"];
    this.size = documentSnapshot["size"];
    this.title = documentSnapshot["title"];
    this.vendor = documentSnapshot["vendor"];
    this.price = documentSnapshot["price"];
    this.phone = documentSnapshot["phone"];
    this.whatsapp = documentSnapshot["whatsapp"];
    this.description = documentSnapshot["description"];
    this.photos = List<String>.from(documentSnapshot["photos"]);
  }

  Product.generateId(){

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference products = db.collection("my_products");
    this.id = products.doc().id;

    this.photos = [];

  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "state": this.state,
      "category": this.category,
      "places": this.places,
      "size" : this.size,
      "title": this.title,
      "vendor": this.vendor,
      "price": this.price,
      "phone": this.phone,
      "whatsapp": this.whatsapp,
      "description": this.description,
      "photos": this.photos,
    };

    return map;

  }

  // ignore: unnecessary_getters_setters
  List<String> get photos => _photos;

  // ignore: unnecessary_getters_setters
  set photos(List<String> value) {
    _photos = value;
  }

  // ignore: unnecessary_getters_setters
  String get description => _description;

  // ignore: unnecessary_getters_setters
  set description(String value) {
    _description = value;
  }

  // ignore: unnecessary_getters_setters
  String get phone => _phone;

  // ignore: unnecessary_getters_setters
  set phone(String value) {
    _phone = value;
  }

  // ignore: unnecessary_getters_setters
  String get whatsapp => _whatsapp;

  // ignore: unnecessary_getters_setters
  set whatsapp(String value) {
    _whatsapp = value;
  }

  // ignore: unnecessary_getters_setters
  String get price => _price;

  // ignore: unnecessary_getters_setters
  set price(String value) {
    _price = value;
  }

  // ignore: unnecessary_getters_setters
  String get vendor => _vendor;

  // ignore: unnecessary_getters_setters
  set vendor(String value) {
    _vendor = value;
  }

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  set title(String value) {
    _title = value;
  }

  // ignore: unnecessary_getters_setters
  String get places => _places;

  // ignore: unnecessary_getters_setters
  set places(String value) {
    _places = value;
  }

  // ignore: unnecessary_getters_setters
  String get size => _size;

  // ignore: unnecessary_getters_setters
  set size(String value) {
    _size = value;
  }

  // ignore: unnecessary_getters_setters
  String get category => _category;

  // ignore: unnecessary_getters_setters
  set category(String value) {
    _category = value;
  }

  // ignore: unnecessary_getters_setters
  String get state => _state;

  // ignore: unnecessary_getters_setters
  set state(String value) {
    _state = value;
  }

  // ignore: unnecessary_getters_setters
  String get id => _id;

  // ignore: unnecessary_getters_setters
  set id(String value) {
    _id = value;
  }
}