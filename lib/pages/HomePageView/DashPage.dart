import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';

import '../../scoped_models/MainModel.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  MainModel _staticModel;

  Widget _buildAppBar() {
    var _address = _staticModel.currentLocation;
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.1),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.white,
              size: 25.0,
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Marquee(
                text:
                    '${_address['thoroughfare']}, ${_address['locality']}, ${_address['administrativeArea']}',
                scrollAxis: Axis.horizontal,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                crossAxisAlignment: CrossAxisAlignment.end,
                velocity: 30.0,
                blankSpace: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: Duration(seconds: 3),
        enlargeCenterPage: true,
      ),
      items: <Widget>[
        Container(
          child: Image.asset('assets/images/carousel/furniture.jpg'),
          margin: EdgeInsets.all(12),
        ),
        Container(
          child: Image.asset('assets/images/carousel/pipe.jpg'),
          margin: EdgeInsets.all(12),
        ),
        Container(
          child: Image.asset('assets/images/carousel/room.jpg'),
          margin: EdgeInsets.all(12),
        ),
        Container(
          child: Image.asset('assets/images/carousel/pest.jpg'),
          margin: EdgeInsets.all(12),
        ),
      ],
    );
  }

  Widget _buildTile(int index) {
    String _title = _staticModel.services[index]['serviceName'];
    String _subtitle = '';
    String _image = _staticModel.services[index]['image'];
    for (Map<String, dynamic> subService in _staticModel.services[index]
        ['subService']) _subtitle += subService['name'] + ' | ';
    _subtitle = _subtitle.substring(0, _subtitle.length - 3);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/SubServicePage',
        arguments: index,
      ),
      child: ListTile(
        leading: Image.asset(_image),
        title: Text(_title),
        subtitle: Text(_subtitle),
        trailing: Icon(Icons.arrow_forward),
      ),
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

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        _buildCarousel(),
        _buildTile(0),
        _buildDivider(),
        _buildTile(1),
        _buildDivider(),
        _buildTile(2),
        _buildDivider(),
        _buildTile(3),
        _buildDivider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _staticModel = ScopedModel.of<MainModel>(context, rebuildOnChange: false);
    return Scaffold(
      body: _buildBody(),
      appBar: _buildAppBar(),
    );
  }
}
