import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import '../../model/Order.dart';
import '../../scoped_models/MainModel.dart';

class PastOrderPage extends StatefulWidget {
  @override
  _PastOrderPageState createState() => _PastOrderPageState();
}

class _PastOrderPageState extends State<PastOrderPage> {
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

  // Widget _buildSingleOrder(Order order) {
  Widget _buildSingleOrder() {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed('/OrderDetailsPage',
        //     arguments: OrderDetailsClass(order));
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
            // _buildOrderTitle(order.serviceName),
            _buildOrderTitle("Order Title"),
            // _buildOrderSubService(order.subService),
            _buildOrderSubService("Order sub service"),
            SizedBox(height: 10.0),
            // _buildOrderDetail(order.desc),
            _buildOrderDetail("Order Description"),
            SizedBox(height: 10.0),
            // _buildOrderStatus(order.status[order.status.length - 1]),
            _buildOrderStatus("This is the order status"),
          ],
        ),
      ),
    );
  }


  Widget _buildBody() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return ListView.builder(
        itemBuilder: (context, index) {
          // Order _order = model.orderList[index];
          // if (_order.isComplete)
          // return _buildSingleOrder(_order);
          return _buildSingleOrder();
          // else
          //   return Container();
        },
        // itemCount: model.orderList.length,
        itemCount: 3,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
