import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../scoped_models/MainModel.dart';
import '../../utils/CustomDialogs.dart';

class OTPPage extends StatefulWidget {
  final String countryCode, phone;

  OTPPage({@required this.countryCode, @required this.phone});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  double _height, _width;

  Widget _buildAppbar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Text(
        'Login/SignUp',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildOTPInput() {
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: PinCodeTextField(
            keyboardType: TextInputType.number,
            wrapAlignment: WrapAlignment.spaceEvenly,
            onDone: (s) async {
              CustomDialogs.loadingDialog(
                  context: context,
                  message: 'Verifying OTP',
                  dismissible: false);

              int res = await model.verifyOTP(otp: s);

              Navigator.of(context).pop();

              if (res == 1)
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/HomePage', (Route r) => false);
              else if (res == 2)
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/SignupPage', (Route r) => false);
              else
                CustomDialogs.alertDialog1(
                    context: context,
                    message: 'An Error Occured',
                    dismissible: false);
            },
            autofocus: true,
            maxLength: 6,
            pinBoxHeight: _height * 0.07,
            pinBoxWidth: _width * 0.1,
            hasTextBorderColor: Colors.green,
            defaultBorderColor: Colors.grey,
            highlightColor: Colors.blue,
            highlight: true,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
            child: Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              'We have sent a verification code on: ',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Text(widget.countryCode + ' ' + widget.phone),
          _buildOTPInput(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }
}
