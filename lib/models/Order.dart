import 'package:flutter/foundation.dart';

class Order {
  final String serviceName, desc, orderID, subService;
  String imageURL, uid;
  final int count, serviceID, subServiceID;
  List<String> status;
  double lat, long, price; //TODO: Implement bid logic for prices
  final bool isComplete;

  Order({
    @required this.serviceName,
    @required this.desc,
    @required this.serviceID,
    @required this.subServiceID,
    @required this.count,
    @required this.subService,
    @required this.isComplete,
    @required this.orderID,
    this.price,
    this.lat,
    this.long,
    this.status,
    this.uid,
    this.imageURL = "null",
  });

  void setPrice(double price) {
    this.price = price;
  }

  void setLocation(double long, double lat) {
    this.lat = lat;
    this.long = long;
  }

  void setStatus(List<String> status) {
    this.status = status;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setImageURL(String imageURL) {
    this.imageURL = imageURL;
  }

  factory Order.fromMap({@required Map<String, dynamic> map}) {
    List<String> _status = List<String>();
    for (String s in map['status']) _status.add(s);
    return Order(
      count: map['count'],
      desc: map['desc'],
      orderID: map['orderID'],
      serviceID: map['serviceID'],
      subServiceID: map['subServiceID'],
      uid: map['uid'],
      price: map['price'],
      lat: map['lat'],
      subService: map['subService'],
      status: _status,
      long: map['long'],
      imageURL: map['imageURL'],
      isComplete: map['isComplete'],
      serviceName: map['serviceName'],
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'count': count,
      'serviceName': serviceName,
      'desc': desc,
      'orderID': orderID,
      'imageURL': imageURL,
      'price': price,
      'serviceID': serviceID,
      'subServiceID': subServiceID,
      'uid': uid,
      'status': status,
      'subService': subService,
      'lat': lat,
      'long': long,
      'isComplete': isComplete,
    };
  }
}
