import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:blood_pressure/pages/add.dart';
import 'package:blood_pressure/pages/history.dart';
import 'package:blood_pressure/pages/setting.dart';
import 'package:blood_pressure/pages/stats.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<String> _pageTitle = ["Blood Pressure Log", "History", "Stats", "Settings"];

  ScreenshotController screenshotController = ScreenshotController();

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
        actions: [
          ((_currentIndex == 1) || (_currentIndex == 2))
              ? InkWell(
                  child: Icon(Icons.share),
                  onTap: () async {
                    // take snapshot and share
                    screenshotController.capture(delay: Duration(milliseconds: 200)).then((uint8List) async {
                      shareImage(uint8List);
                    }).catchError((onError) {
                      log(onError.toString());
                    });
                  },
                )
              : Container()
        ],
      ),
      body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                AddPage(),
                HistoryPage(),
                StatsPage(),
                SettingPage(),
              ],
            ),
          )),
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

  Future<dynamic> showCapturedWidget(BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured screenshot"),
        ),
        body: Center(child: capturedImage != null ? Image.memory(capturedImage) : Container()),
      ),
    );
  }

  saveToGallery(File image) async {
    final result = await ImageGallerySaver.saveImage(image.readAsBytesSync());
    print("File Saved to Gallery");
  }

  shareImage(Uint8List uint8List) async {
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    String filePath = appDocPath + "/" + DateFormat('yMMdd').format(DateTime.now()).toString() + "_export" + ".png";
    final File file = File(filePath);
    await file.writeAsBytes(uint8List);
    log(filePath);
    //open share dialog
    Share.shareFiles([filePath]);
  }
}
