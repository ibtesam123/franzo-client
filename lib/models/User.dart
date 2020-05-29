import 'package:flutter/foundation.dart';

class User {
  String uid, name, email, phone, imageURL;
  List<String> orders;
  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.imageURL,
    @required this.orders,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      orders: map['orders'],
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
      'orders': orders,
      'imageURL': imageURL
    };
  }
}