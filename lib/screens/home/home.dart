import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolie_mobile/constants.dart';
import 'package:wolie_mobile/screens/home/home_screen.dart';
import 'package:wolie_mobile/screens/home/profile_screen.dart';
import 'package:wolie_mobile/screens/home/stores_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        floatingActionButton: FloatingActionButton(
//          backgroundColor: Colors.blueAccent[100],
//          child: Icon(Icons.add),
//          onPressed: () {
//            showModalBottomSheet(
//                context: context,
//                builder: (BuildContext context) => AddStoreScreen());
//          },
//        ),
      appBar: AppBar(
        title: Text('Wolie'),
        backgroundColor: Colors.blueAccent[200],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          HomeScreen(),
          StoresScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: kCreditCardColor1,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.store,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
