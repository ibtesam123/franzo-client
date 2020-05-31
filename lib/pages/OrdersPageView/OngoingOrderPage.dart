import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/MainModel.dart';
import '../../models/Order.dart';
import '../../utils/ArgumentClasses.dart';

class OngoingOrderPage extends StatefulWidget {
  @override
  _OngoingOrderPageState createState() => _OngoingOrderPageState();
}

class _OngoingOrderPageState extends State<OngoingOrderPage> {
  Widget _buildOrderTitle(String serviceName) {
    return Text(
      serviceName,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderSubService(String subService) {
    return Text(
      subService,
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildOrderDetail(String desc) {
    return desc.trim().length == 0
        ? Text(
            'No description provided.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15.0,
            ),
          )
        : Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.0),
          );
  }

  Widget _buildOrderStatus(String status) {
    return Text(
      status,
      style: TextStyle(fontSize: 12.0, color: Colors.black45),
    );
  }

  Widget _buildSingleOrder(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/OrderDetailsPage',
            arguments: OrderDetailsClass(order.orderID));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.black54, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildOrderTitle(order.serviceName),
            _buildOrderSubService(order.subService),
            SizedBox(height: 10.0),
            _buildOrderDetail(order.desc),
            SizedBox(height: 10.0),
            _buildOrderStatus(order.status[order.status.length - 1]),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return ListView.builder(
        itemBuilder: (context, index) {
          Order _order = model.orderList[index];
          if (!_order.isComplete)
            return _buildSingleOrder(_order);
          else
            return Container();
        },
        itemCount: model.orderList.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
