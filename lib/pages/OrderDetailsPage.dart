import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/MainModel.dart';
import '../models/Order.dart';
import '../models/BidPrice.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderID;
  OrderDetailsPage({@required this.orderID});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  double _height, _width;
  MainModel _staticModel;

  @override
  void initState() {
    super.initState();
    _staticModel = ScopedModel.of<MainModel>(context);
  }

  Widget _buildBiddingList(Order order) {
    return ListView.builder(
      itemBuilder: (_, index) {
        BidPrice bidPrice = order.price[index];
        return bidPrice.companyID == null
            ? Text('Bid Starting at: ${bidPrice.price.toString()}')
            : Row(
                children: <Widget>[
                  Text(
                    bidPrice.companyName + ' : ' + bidPrice.price.toString(),
                  ),
                  SizedBox(width: _width * 0.2),
                  MaterialButton(
                    onPressed: () {
                      _staticModel.acceptBid(order, bidPrice.companyID);
                      this.setState(() {});
                    },
                    child: Text('Accept'),
                  )
                ],
              );
      },
      itemCount: order.price.length,
    );
  }

  Widget _buildStatusList(Order order) {
    return ListView.builder(
      itemBuilder: (_, index) {
        return Text(order.status[index]);
      },
      itemCount: order.status.length,
    );
  }

  Widget _buildBody() {
    return StreamBuilder<DocumentSnapshot>(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          Order _order = Order.fromMap(map: snapshot.data.data);
          if (_order.bidEnabled && !_order.isComplete) {
            return _buildBiddingList(_order);
          } else {
            return _buildStatusList(_order);
          }
        } else {
          return Container();
        }
      },
      stream: _staticModel.getBiddingStream(widget.orderID),
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
