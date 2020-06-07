import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './scoped_models/MainModel.dart';
import './pages/SplashPage.dart';
import './pages/auth/LoginPage.dart';
import './pages/HomePage.dart';
import './pages/auth/SignupPage.dart';
import './pages/SubServicePage.dart';
import './pages/ServiceDetailsPage.dart';
import './pages/OrderPlacedPage.dart';
import './pages/OrderDetailsPage.dart';
import './utils/ArgumentClasses.dart';

void main() {
  MainModel _model = MainModel();
  runApp(MyMaterial(
    model: _model,
  ));
}

class MyMaterial extends StatelessWidget {
  final MainModel model;

  MyMaterial({@required this.model});

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.grey
        ),
        routes: {
          '/': (context) => SplashPage(),
          '/LoginPage': (context) => LoginPage(),
          '/HomePage': (context) => HomePage(),
          '/SignupPage': (context) => SignupPage(),
          '/OrderPlacedPage': (context) => OrderPlacedPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/SubServicePage':
              var _index = settings.arguments.toString();
              return MaterialPageRoute(
                builder: (_) => SubServicePage(serviceIndex: int.parse(_index)),
              );
            case '/ServiceDetailsPage':
              ServiceDetailClass _arguments = settings.arguments;
              return MaterialPageRoute(
                builder: (_) => ServiceDetailsPage(
                  serviceIndex: _arguments.serviceIndex,
                  subServiceIndex: _arguments.subServiceIndex,
                ),
              );
            case '/OrderDetailsPage':
              OrderDetailsClass _arguments = settings.arguments;
              return MaterialPageRoute(
                builder: (_) => OrderDetailsPage(orderID: _arguments.orderID),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
