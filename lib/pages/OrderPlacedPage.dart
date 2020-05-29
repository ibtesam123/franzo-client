import 'package:flutter/material.dart';

class OrderPlacedPage extends StatefulWidget {
  @override
  _OrderPlacedPageState createState() => _OrderPlacedPageState();
}

class _OrderPlacedPageState extends State<OrderPlacedPage> {
  Widget buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 55,
            ),
            SizedBox(height: 22),
            Text(
              'Order Success',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Text(
              'Your Order has been placed successfully, we will get back to you shortly',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 40),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/HomePage',
                  (route) => false,
                );
              },
              color: Colors.white,
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                'Go to Home',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: buildBody(),
    );
  }
}
