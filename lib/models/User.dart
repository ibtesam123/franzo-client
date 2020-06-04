import 'package:flutter/foundation.dart';

class User {
  String uid, name, email, phone, imageURL;
  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.imageURL, 
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      imageURL: map['imageURL'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'imageURL': imageURL
    };
  }
}
