import 'package:blood_pressure/pages/home.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // force status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: kPrimaryColor),
    );
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
