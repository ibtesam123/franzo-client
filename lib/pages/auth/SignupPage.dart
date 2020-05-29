import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../scoped_models/MainModel.dart';
import '../../utils/CustomDialogs.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  String _fName, _lName, _email;

  void _getImage() {
    this.setState(() async {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  Widget _buildAvatar() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: _image == null
                  ? AssetImage('assets/images/defaultpp.png')
                  : FileImage(_image),
              radius: 62,
            ),
          ),
          Container(
            child: FloatingActionButton(
              onPressed: () {
                _getImage();
              },
              mini: true,
              tooltip: 'Change Photo',
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 2, 75, 0, 0),
          )
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'EMAIL',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Please enter a valid email';
          } else
            return null;
        },
        onSaved: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildFirstNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'FIRST NAME',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Invalid Name';
          } else
            return null;
        },
        onSaved: (value) {
          _fName = value;
        },
      ),
    );
  }

  Widget _buildLastNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'LAST NAME',
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Invalid Name';
          } else
            return null;
        },
        onSaved: (value) {
          _lName = value;
        },
      ),
    );
  }

  Widget _buildSignupButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: MaterialButton(
          height: 40,
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.black,
          onPressed: () async {
            if (model.isLoading == -1) {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();
              var res = await model.signupUser(
                  name: _fName + ' ' + _lName, email: _email);
              if (res)
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/HomePage',
                  (r) => false,
                );
              else
                CustomDialogs.alertDialog1(
                    context: context,
                    message: 'Error Occured.',
                    dismissible: false);
            }
          },
          child: model.isLoading == 1
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      );
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 65),
              child: Text(
                'SignUp.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            _buildAvatar(),
            _buildEmailField(),
            _buildFirstNameField(),
            _buildLastNameField(),
            _buildSignupButton(),
          ],
        ),
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
