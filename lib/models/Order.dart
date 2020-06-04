import 'package:flutter/foundation.dart';

import './BidPrice.dart';

class Order {
  final String serviceName, desc, orderID, subService;
  String imageURL, uid, companyID;
  final int count, serviceID, subServiceID;
  List<String> status;
  double lat, long;
  bool isComplete;
  bool bidEnabled;
  final List<BidPrice> price;

  Order({
    @required this.serviceName,
    @required this.desc,
    @required this.serviceID,
    @required this.subServiceID,
    @required this.count,
    @required this.subService,
    @required this.isComplete,
    @required this.orderID,
    @required this.price,
    @required this.bidEnabled,
    this.lat,
    this.long,
    this.status,
    this.uid,
    this.imageURL = "null",
    this.companyID,
  });

  void setLocation(double long, double lat) {
    this.lat = lat;
    this.long = long;
  }

  void setCompanyID(String id) {
    companyID = id;
  }

  void setStatus(List<String> status) {
    this.status = status;
  }

  void setBidEnabled(bool status) {
    this.bidEnabled = status;
  }

  void setIsComplete(bool status){
    this.isComplete=status;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setImageURL(String imageURL) {
    this.imageURL = imageURL;
  }

  factory Order.fromMap({@required Map<String, dynamic> map}) {
    List<String> _status = List<String>();
    List<BidPrice> _price = List<BidPrice>();
    for (String s in map['status']) _status.add(s);
    for (Map<String, dynamic> bid in map['price'])
      _price.add(BidPrice.fromMap(bid));

    return Order(
      count: map['count'],
      desc: map['desc'],
      orderID: map['orderID'],
      serviceID: map['serviceID'],
      subServiceID: map['subServiceID'],
      uid: map['uid'],
      price: _price,
      companyID: map['companyID'],
      lat: map['lat'],
      bidEnabled: map['bidEnabled'],
      subService: map['subService'],
      status: _status,
      long: map['long'],
      imageURL: map['imageURL'],
      isComplete: map['isComplete'],
      serviceName: map['serviceName'],
    );
  }

  Map<String, dynamic> getMap() {
    List<Map<String, dynamic>> _price = List<Map<String, dynamic>>();
    for (BidPrice bid in price) _price.add(bid.toMap());
    return {
      'count': count,
      'serviceName': serviceName,
      'desc': desc,
      'orderID': orderID,
      'imageURL': imageURL,
      'price': _price,
      'companyID': companyID,
      'serviceID': serviceID,
      'subServiceID': subServiceID,
      'uid': uid,
      'bidEnabled': bidEnabled,
      'status': status,
      'subService': subService,
      'lat': lat,
      'long': long,
      'isComplete': isComplete,
    };
  }
}
