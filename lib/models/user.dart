import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String _idUser;
  String _name;
  String _userName;
  String _email;
  String _bio;
  String _location;
  String _urlImage;
  String _permission;
  String _password;

  Users();

  Users.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
     this.idUser = documentSnapshot.id;
     this.name = documentSnapshot["name"];
     this.userName = documentSnapshot["userName"];
     this.email = documentSnapshot["email"];
     this.bio = documentSnapshot["bio"];
     this.location = documentSnapshot["location"];
     this.urlImage = documentSnapshot["urlImage"];
     this.permission = documentSnapshot["permission"];
  }

  String verifyPermission(bool permission) {
    return permission ? "vendor" : "client";
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUser" : this.idUser,
      "name" : this.name,
      "userName" : this.userName,
      "email" : this.email,
      "bio" : this.bio,
      "location" : this.location,
      "permission" : this.permission,
      "urlImage" : this.urlImage,
    };

    return map;

  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get bio => _bio;

  set bio(String value) {
    _bio = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  String get permission => _permission;

  set permission(String value) {
    _permission = value;
  }
}