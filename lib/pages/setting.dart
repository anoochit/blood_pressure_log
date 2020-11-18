import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static List<String> menuItems = [
    "Backup to Google Drive",
    "Export as CSV",
    "About",
  ];

  List<IconData> menuIcon = [
    Icons.settings_backup_restore_outlined,
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
        break;
      case 1:
        break;

      case 2:
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
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });

        break;
    }
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
            size: 36,
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
