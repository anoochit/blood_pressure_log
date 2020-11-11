import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/pages/home.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void main() {
  Hive.registerAdapter(BpAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BP Log',
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        canvasColor: kCanvasColor,
        textTheme: kTextTheme,
      ),
      home: HomePage(),
    );
  }
}
