import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';

import '../models/User.dart';
import '../models/Order.dart';
import '../pages/auth/OTPPage.dart';

mixin ConnectedModel on Model {
  int _isLoading;
  FirebaseAuth _fAuth;
  FirebaseUser _fUser;
  User _currentUser;
  Firestore _remoteDB;
  StorageReference _remoteStorage;
  Map<String, dynamic> _currentLocation;
  List<Order> _orderList;

  List<Map<String, dynamic>> _services = [
    {
      'serviceName': 'Cleaning Service',
      'id': 0,
      'subService': [
        {
          'id': 0,
          'name': 'BathRoom',
          'image': 'assets/images/listing/room.jpg',
          'price': 200,
        },
        {
          'id': 1,
          'name': 'Sofa',
          'image': 'assets/images/listing/room.jpg',
          'price': 150,
        },
        {
          'id': 2,
          'name': 'Kitchen',
          'image': 'assets/images/listing/room.jpg',
          'price': 600,
        },
      ],
      'image': 'assets/images/listing/room.jpg',
    },
    {
      'serviceName': 'Home Repair',
      'id': 1,
      'subService': [
        {
          'id': 3,
          'name': 'Plumber',
          'image': 'assets/images/listing/electric.jpg',
          'price': 150,
        },
        {
          'id': 4,
          'name': 'Electrician',
          'image': 'assets/images/listing/electric.jpg',
          'price': 180,
        },
        {
          'id': 5,
          'name': 'Carpenter',
          'image': 'assets/images/listing/electric.jpg',
          'price': 280,
        },
      ],
      'image': 'assets/images/listing/electric.jpg',
    },
    {
      'serviceName': 'Saloon Service',
      'id': 2,
      'subService': [
        {
          'id': 6,
          'name': 'Grooming',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 750,
        },
        {
          'id': 7,
          'name': 'Hair Cut',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 150,
        },
        {
          'id': 8,
          'name': 'Massage',
          'image': 'assets/images/listing/grooming.jpg',
          'price': 800,
        },
      ],
      'image': 'assets/images/listing/grooming.jpg',
    },
    {
      'serviceName': 'Electronic Repair',
      'id': 3,
      'subService': [
        {
          'id': 9,
          'name': 'Laptops',
          'image': 'assets/images/listing/electronic.jpg',
          'price': 450,
        },
        {
          'id': 10,
          'name': 'Mobiles',
          'image': 'assets/images/listing/electronic.jpg',
          'price': 200,
        },
      ],
      'image': 'assets/images/listing/electronic.jpg',
    }
  ];
}

/* isLoading
 * 1: Signup User
 * 2: Place Order
*/

mixin UserModel on ConnectedModel {
  String _verID, _phone;

  Future<void> signInWithPhoneNumber({
    @required String phone,
    @required String countryCode,
    @required BuildContext context,
  }) async {
    _phone = phone;
    final PhoneCodeAutoRetrievalTimeout _codeTimeout = (String verID) {
      this._verID = verID;
    };
    final PhoneVerificationCompleted _verifyCompleted = (AuthCredential cred) {
      print('Verify Completed');
    };
    final PhoneVerificationFailed _verifyFailed = (AuthException error) {
      print(error.toString());
    };
    final PhoneCodeSent _codeSent = (String verID, [int forceResendingToken]) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OTPPage(
          countryCode: countryCode,
          phone: phone,
        ),
      ));
    };

    _fAuth.verifyPhoneNumber(
      phoneNumber: countryCode + phone,
      timeout: Duration(seconds: 0),
      verificationCompleted: _verifyCompleted,
      verificationFailed: _verifyFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeTimeout,
    );
  }

  Future<int> verifyOTP({@required String otp}) async {
    /*
      * 0: Error
      * 1: User exists
      * 2: User does not exist
    */

    try {
      AuthCredential _cred =
          PhoneAuthProvider.getCredential(verificationId: _verID, smsCode: otp);

      AuthResult _result = await _fAuth.signInWithCredential(_cred);
      _fUser = _result.user;

      if (_fUser == null) {
        return 0;
      }

      var _snap = await _remoteDB.collection('USERS').getDocuments();
      for (DocumentSnapshot doc in _snap.documents) {
        if (doc.documentID == _fUser.uid) {
          _currentUser = User.fromMap(doc.data);
          return 1;
        }
      }

      // TODO: sync user with localDB

      return 2;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> signOut() async {
    await _fAuth.signOut();
    return true;
  }

  Future<bool> signupUser({
    @required String name,
    @required String email,
  }) async {
    try {
      _isLoading = 1;
      notifyListeners();

      _currentUser = User(
        uid: _fUser.uid,
        name: name,
        email: email,
        phone: _phone,
        imageURL: "null",
        orders: List<String>(),
      );

      _remoteDB
          .collection('USERS')
          .document(_fUser.uid)
          .setData(_currentUser.toMap());

      //TODO: sync user with localDB

      _isLoading = -1;
      notifyListeners();
      return true;
    } catch (err) {
      _isLoading = -1;
      notifyListeners();
      return false;
    }
  }
}

mixin OrderModel on ConnectedModel {
  Future<bool> placeOrder({
    @required Map<String, dynamic> service,
    @required Map<String, dynamic> subService,
    @required int count,
    @required String desc,
    @required File image,
  }) async {
    try {
      _isLoading = 2;
      notifyListeners();
      List<String> _orderStatus = List<String>();
      _orderStatus.add(
        'Order Placed on ' +
            DateFormat('dd MMMM yyyy hh:mm a').format(DateTime.now()),
      );
      Order _order = Order(
        count: count,
        desc: desc,
        isComplete: false,
        orderID: randomAlphaNumeric(20),
        serviceID: service['id'],
        subServiceID: subService['id'],
        serviceName: service['serviceName'],
        subService: subService['name'],
        lat: _currentLocation['position']['latitude'],
        long: _currentLocation['position']['longitude'],
        price: double.parse(subService['price'].toString()),
        status: _orderStatus,
        uid: _currentUser.uid,
      );

      //Upload image if available to storage
      if (image != null) {
        var _snap = await _remoteStorage
            .child('ORDER_IMAGES')
            .child(_order.orderID)
            .putFile(image)
            .onComplete;

        var _imageURL = await _snap.ref.getDownloadURL();
        _order.setImageURL(_imageURL);
      }

      _currentUser.orders.add(_order.orderID);

      //TODO: save orderlist of users to localDB
      //TODO: Add order to localDB

      //Upload order to database
      _remoteDB
          .collection('ORDERS')
          .document(_order.orderID)
          .setData(_order.getMap());

      _remoteDB
          .collection('USERS')
          .document(_currentUser.uid)
          .setData(_currentUser.toMap(), merge: true);

      _isLoading = -1;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = -1;
      notifyListeners();
      return false;
    }
  }

  void updateOrder(Order order, int index) {
    _orderList[index] = order;
    //TODO: Update in localDB
  }
}

mixin UtilityModel on ConnectedModel {
  Future<bool> init() async {
    _isLoading = -1;
    _fAuth = FirebaseAuth.instance;
    _fUser = await _fAuth.currentUser();
    _remoteDB = Firestore.instance;
    _remoteStorage = FirebaseStorage.instance.ref();
    _orderList = List<Order>(); //TODO: Get order list from localDB

    //Get user's current location
    Position _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var _placemarks = await Geolocator().placemarkFromPosition(_position);
    _currentLocation = _placemarks[0].toJson();

    if (_fUser == null)
      return false;
    else {
      // TODO: Fetch user from localDB instead
      var doc = await _remoteDB.collection('USERS').document(_fUser.uid).get();
      _currentUser = User.fromMap(doc.data);

      var _snap = await _remoteDB.collection('ORDERS').getDocuments();
      var _docs = _snap.documents;
      for (DocumentSnapshot doc in _docs) {
        if (_currentUser.orders.contains(doc.documentID)) {
          _orderList.add(Order.fromMap(map: doc.data));
        }
      }

      return true;
    }
  }

  int get isLoading => _isLoading;
  User get currentUser => _currentUser;
  List<Map<String, dynamic>> get services => _services;
  List<Order> get orderList => _orderList;
  Map<String, dynamic> get currentLocation => _currentLocation;
}
