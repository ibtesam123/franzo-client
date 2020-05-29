import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/MainModel.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _buildInfo() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Text(
        model.currentUser.toMap().toString(),
      );
    });
  }

  Widget _buildLogoutButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return MaterialButton(
        onPressed: () async {
          if (model.isLoading == -1) {
            var res = await model.signOut();
            if (res)
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/LoginPage',
                (route) => false,
              );
          }
        },
        child: Text('Logout'),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildInfo(),
        _buildLogoutButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
