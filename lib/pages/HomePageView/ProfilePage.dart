import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

import '../../scoped_models/MainModel.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'My Profile',
        style: TextStyle(color: Colors.white),
      ),
      elevation: 4,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildProfileData() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Row(
        children: <Widget>[
          CircleAvatar(
            foregroundColor: Colors.red,
            radius: 30,
            backgroundImage: model.currentUser.imageURL != 'null'
                ? NetworkImage(model.currentUser.imageURL)
                : AssetImage('assets/images/defaultpp.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  model.currentUser.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                Text(model.currentUser.phone),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _buildEditButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {},
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildProfileData(),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildServiceItems(String n, IconData icon) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 22,
        ),
        SizedBox(width: 10),
        Text(
          n,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Divider(
        indent: 22,
        color: Colors.black,
      ),
    );
  }

  Widget _buildService() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(13),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: _buildServiceItems('Help Center', Icons.chat),
            ),
            _buildDivider(),
            _buildServiceItems('About Franzo', Icons.info),
            _buildDivider(),
            GestureDetector(
              onTap: () {
                Share.share('Checkout the all new Franzo App www.google.com');
              },
              child: _buildServiceItems('Share Franzo', Icons.share),
            ),
            _buildDivider(),
            GestureDetector(
                onTap: () {
                  LaunchReview.launch(androidAppId: "farhaz.alam.fweather2");
                },
                child: _buildServiceItems('Rate Franzo', Icons.star)),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildInfo(),
        SizedBox(height: 10),
        _buildService(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
