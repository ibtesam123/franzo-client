import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/MainModel.dart';
import '../models/Order.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderID;
  OrderDetailsPage({@required this.orderID});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  double _height, _width;
  MainModel _staticModel;
  int _index;
  Order _order;

  @override
  void initState() {
    super.initState();
    _staticModel = ScopedModel.of<MainModel>(context);
    _index = _staticModel.orderList
        .indexWhere((element) => element.orderID == widget.orderID);
    Firestore.instance
        .collection('ORDERS')
        .document(widget.orderID)
        .get()
        .asStream()
        .listen((docSnap) {
      this.setState(() {
        _order = Order.fromMap(map: docSnap.data);
        _staticModel.updateOrder(_order, _index);
      });
    });
  }

  Widget _buildBody() {
    return _order == null
        ? Container()
        : Container(
            height: _height,
            width: _width,
            padding: EdgeInsets.only(top: _height * 0.2),
            child: ListView.builder(
              itemBuilder: (_, i) {
                return Text(_order.status[i]);
              },
              itemCount: _order.status.length,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _buildBody(),
    );
  }
}
