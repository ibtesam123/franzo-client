import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';

import '../scoped_models/MainModel.dart';
import '../utils/CustomDialogs.dart';
import '../models/Order.dart';

class ServiceDetailsPage extends StatefulWidget {
  final int serviceIndex, subServiceIndex;

  ServiceDetailsPage({
    @required this.serviceIndex,
    @required this.subServiceIndex,
  });
  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  int _count = 1;
  MainModel _staticModel;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _desc = '';
  File _image;
  Map<String, dynamic> _service, _subService;
  double _height, _width;

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
        _service['serviceName'],
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Material(
        child: Image.asset(
          'assets/images/listing/room.jpg',
        ),
        elevation: 6,
      ),
    );
  }

  Widget _buildQuantity() {
    return Row(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              setState(() {
                if (_count > 1) {
                  _count--;
                }
              });
            },
            child: Icon(Icons.remove_circle_outline)),
        Text(_count < 10
            ? ' 0' + _count.toString() + ' '
            : ' ' + _count.toString() + ' '),
        GestureDetector(
            onTap: () {
              setState(() => _count++);
            },
            child: Icon(Icons.add_circle_outline)),
      ],
    );
  }

  Widget _buildItem() {
    return Container(
      width: _width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildImage(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _subService['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildQuantity(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Container(
        padding: EdgeInsets.only(left: 15.0),
        color: Colors.white,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Enter a detail description of the problem',
            hintStyle: TextStyle(fontSize: 15.0),
          ),
          onSaved: (value) {
            _desc = value;
          },
        ),
      ),
    );
  }

  Widget _buildUploadImage() {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _image == null
              ? Image.asset(
                  'assets/images/defaultpp.png',
                  fit: BoxFit.cover,
                  width: _width * 0.15,
                )
              : Image.file(
                  _image,
                  width: _width * 0.15,
                ),
          SizedBox(width: 35),
          GestureDetector(
            onTap: () async {
              _image = await ImagePicker.pickImage(source: ImageSource.gallery);
              this.setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              height: 36,
              width: 80,
              child: Text('Upload'),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.5, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return GestureDetector(
          onTap: () async {
            if (!_formKey.currentState.validate()) return;
            _formKey.currentState.save();

            Order order = Order(
              count: _count,
              desc: _desc,
              isComplete: false,
              orderID: randomAlphaNumeric(20),
              serviceID: _service['id'],
              serviceName: _service['serviceName'],
              subService: _subService['name'],
              subServiceID: _subService['id'],
            );

            var res = await model.placeOrder(order, _image);

            if (res) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/OrderPlacedPage',
                (route) => false,
              );
            } else {
              CustomDialogs.alertDialog1(
                  context: context,
                  message: 'An Error Occured',
                  dismissible: false);
            }
          },
          child: Material(
            elevation: 6,
            child: Container(
              height: _height * 0.1,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.all(8),
                color: Colors.black,
                alignment: Alignment.centerRight,
                child: model.isLoading == 2
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: _width * 0.08,
                          width: _width * 0.08,
                          margin: EdgeInsets.only(right: 10.0),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Continue ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white),
                          Text('     ')
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 15),
        children: <Widget>[
          _buildItem(),
          _buildUploadImage(),
          _buildDescription(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _staticModel = ScopedModel.of<MainModel>(context, rebuildOnChange: false);
    _service = _staticModel.services[widget.serviceIndex];
    _subService = _service['subService'][widget.subServiceIndex];
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _buildBody(),
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
