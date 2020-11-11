import 'package:blood_pressure/pages/add.dart';
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
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AddPage(),
          Container(),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.indigo[200],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Add',
            icon: Icon(Icons.add_circle_outline),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(Icons.calendar_today_outlined),
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
