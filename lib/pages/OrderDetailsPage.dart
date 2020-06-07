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
            ? Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black54, width: 1.0),
                    color: Colors.white),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Starting at'),
                    Text(
                      'Rs. ${bidPrice.price.toString()}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
              )
            : Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black54, width: 1.0),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            bidPrice.companyName,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Rs. " + bidPrice.price.toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _staticModel.acceptBid(order, bidPrice.companyID);
                        this.setState(() {});
                      },
                      color: Colors.green,
                      child: Text('Accept'),
                    )
                  ],
                ),
              );
      },
      itemCount: order.price.length,
    );
  }
// YAHAN PAR LISTVIEW BUILDER ITERATE KARKE DUPLICATE HO JA RAHA THA ISILIYE HARD CODE KARDIYE
  Widget _buildStatusList(Order order) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(top: _height * 0.3),
      // child: ListView.builder(
      //   itemBuilder: (_, index) {
      //     return
       child:    ListView(
         children: <Widget>[
           Column(
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    order.status[0],
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Your order id is',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    order.orderID,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'The order for ${order.subService} is in process',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    'We will get back to you shortly.',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )
                ],
              ),
         ],
       )
          // ;
      //   },
      //   itemCount: order.status.length,
      // ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      child: StreamBuilder<DocumentSnapshot>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            Order _order = Order.fromMap(map: snapshot.data.data);
            if (_order.bidEnabled && !_order.isComplete) {
              return _buildBiddingList(_order);
            } else {
              
              return _buildStatusList(_order);
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0XFF000000),
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ));
          }
        },
        stream: _staticModel.getBiddingStream(widget.orderID),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'My Orders',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      elevation: 4,
      backgroundColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
