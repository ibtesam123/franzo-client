import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/MainModel.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    ScopedModel.of<MainModel>(context).init().then((isSignedIn) {
      if (isSignedIn)
        Navigator.of(context).pushReplacementNamed('/HomePage');
      else
        Navigator.of(context).pushReplacementNamed('/LoginPage');
    });
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/FRANZO.png'),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(
            backgroundColor: Color(0XFF000000),
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
