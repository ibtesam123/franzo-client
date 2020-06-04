import 'package:flutter/material.dart';

class BidPrice {
  String companyID, companyName;
  double price;

  BidPrice({
    @required this.companyID,
    @required this.companyName,
    @required this.price,
  });

  void setPrice(double price) {
    this.price = price;
  }

  factory BidPrice.fromMap(Map<String, dynamic> map) {
    return BidPrice(
      companyID: map['companyID'],
      companyName: map['companyName'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyID': companyID,
      'companyName': companyName,
      'price': price,
    };
  }
}
