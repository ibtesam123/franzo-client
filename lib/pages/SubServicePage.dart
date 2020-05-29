import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/MainModel.dart';
import '../utils/ArgumentClasses.dart';

class SubServicePage extends StatefulWidget {
  final int serviceIndex;

  SubServicePage({@required this.serviceIndex});

  @override
  _SubServicePageState createState() => _SubServicePageState();
}

class _SubServicePageState extends State<SubServicePage> {
  MainModel _staticModel;

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Text(
        _staticModel.services[widget.serviceIndex]['serviceName'],
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTile(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/ServiceDetailsPage',
              arguments: ServiceDetailClass(widget.serviceIndex, index),
            );
          },
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _staticModel.services[widget.serviceIndex]['subService']
                      [index]['image'],
                  fit: BoxFit.fill,
                )),
            title: Text(
              _staticModel.services[widget.serviceIndex]['subService'][index]
                  ['name'],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 20),
      itemCount:
          _staticModel.services[widget.serviceIndex]['subService'].length,
      itemBuilder: (_, index) {
        return _buildTile(index);
      },
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
