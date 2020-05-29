import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/MainModel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final TextEditingController _phoneTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone, _countryCode;

  Widget _buildCountryCode() {
    return Container(); //TODO: Implement country code
  }

  Widget _buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        enableInteractiveSelection: true,
        maxLength: 10,
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          labelText: 'PHONE NUMBER',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
        keyboardType: TextInputType.phone,
        validator: (String value) {
          if (value.isEmpty || value.length != 10) {
            return 'enter a valid phone number';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _phone = value;
          _countryCode = '+91';
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: MaterialButton(
          height: 40,
          minWidth: MediaQuery.of(context).size.width,
          color: Colors.black,
          onPressed: () async {
            if (model.isLoading == -1) {
              if (!_formKey.currentState.validate()) return;
              _formKey.currentState.save();

              model.signInWithPhoneNumber(
                phone: _phone,
                countryCode: _countryCode,
                context: context,
              );
            }
          },
          child: Text(
            'Login/Signup',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Widget _buildForeground() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              color: Colors.black,
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              'F R A N Z O',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your Home Solution Stop',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            _buildPhoneInput(),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'assets/images/auth.png',
      fit: BoxFit.fill,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      filterQuality: FilterQuality.high,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildBackground(),
        _buildForeground(),
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
