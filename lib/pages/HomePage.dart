import 'package:flutter/material.dart';

import './HomePageView/DashPage.dart';
import './HomePageView/OrdersPage.dart';
import './HomePageView/ProfilePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  double _height;
  int _currentPage = 0;

  Widget _buildBody() {
    return PageView(
      controller: _pageController,
      onPageChanged: (n) => this.setState(() {
        _currentPage = n;
      }),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        DashPage(),
        OrdersPage(),
        ProfilePage(),
      ],
    );
  }

  Widget buildAppBarIcons(String name, IconData icon, int n) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(n,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        setState(() => _currentPage = n);
      },
      child: Column(
        children: <Widget>[
          _currentPage == n
              ? Icon(icon)
              : Icon(
                  icon,
                  color: Colors.grey,
                ),
          _currentPage == n
              ? Text(name)
              : Text(
                  name,
                  style: TextStyle(color: Colors.grey),
                )
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      elevation: 7,
      color: Colors.grey[200],
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0)),
        child: Container(
          height: _height * 0.08,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildAppBarIcons('HomePage', Icons.home, 0),
              buildAppBarIcons('Bookings', Icons.work, 1),
              buildAppBarIcons('Profile', Icons.portrait, 2),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
