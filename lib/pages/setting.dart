import 'dart:developer';
import 'dart:io';

import 'package:blood_pressure/models/bp.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static List<String> menuItems = [
    "Export as CSV",
    "About",
  ];

  List<IconData> menuIcon = [
    Icons.import_export_rounded,
    Icons.info_outline_rounded,
  ];

  List<Color> menuColor = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.blue,
  ];

  onAction(int index, BuildContext context) {
    switch (index) {
      case 0:
        exportAsCSV();
        break;

      case 1:
        showAbout();
        break;
    }
  }

  exportAsCSV() async {
    // load data to list
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(BpAdapter());
    }
    // hive open box
    Box<Bp> box = await Hive.openBox<Bp>("bloodPressure");

    List<List<String>> bpDocument = [
      <String>['Date', 'Sys', 'Dia', 'Pul', 'Typ'],
    ];

    box.values.forEach((element) {
      //log(element.dateTime.toString());
      bpDocument.add(<String>[element.dateTime.toString(), element.systolic.toString(), element.diastolic.toString(), element.pulse.toString(), element.type.toString()]);
    });

    String csv = const ListToCsvConverter(fieldDelimiter: ',', eol: '\n', textDelimiter: '"', textEndDelimiter: '"').convert(bpDocument);

    // get application directory
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;

    String filePath = appDocPath + "/" + DateFormat('yMMdd').format(DateTime.now()).toString() + "_export" + ".csv";

    final File file = File(filePath);
    await file.writeAsString(csv);

    log(csv);

    log(filePath);

    //final message = await OpenFile.open(filePath);
    //log(message.message.toString());

    //open share dialog
    Share.shareFiles([filePath]);
  }

  showAbout() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("About"),
          content: new Text(appName + " v" + version + "+" + buildNumber),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(
            menuIcon[index],
            //color: menuColor[index % 5],
            color: Colors.indigo,
            size: 32,
          ),
          title: Text(
            menuItems[index],
            style: TextStyle(fontSize: 18.0),
          ),
          onTap: () {
            onAction(index, context);
          },
        );
      },
    );
  }
}
