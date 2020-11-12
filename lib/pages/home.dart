import 'package:blood_pressure/pages/add.dart';
import 'package:blood_pressure/pages/history.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<String> _pageTitle = [
    "Blood Pressure Log",
    "History",
    "Stats",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _pageTitle[_currentIndex],
          style: kAppBarTitle,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AddPage(),
          HistoryPage(),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBottomNavigationBarBackgroundColor,
        currentIndex: _currentIndex,
        fixedColor: kBottomNavigationBarFixedColor,
        unselectedItemColor: kBottomNavigationBarUnselectedItemColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Add',
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(Icons.today_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Stats',
            icon: Icon(Icons.bar_chart_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
