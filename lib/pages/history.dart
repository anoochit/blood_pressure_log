import 'package:blood_pressure/models/bp.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  static const List<String> typeList = [
    "Hypotension",
    "Normal",
    "Prehypertension",
    "Stage 1 Hypertension",
    "Stage 2 Hypertension",
  ];

  Future<Iterable<Bp>> getData() async {
    // add blood pressure data
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(BpAdapter());
    }
    // hive open box
    Box<Bp> box = await Hive.openBox<Bp>("bloodPressure");
    //box.clear();
    // return box.values.where(
    //     (datetime) => datetime.dateTime.toString().startsWith("2020-11"));
    return box.values;
  }

  _buildList(BuildContext context, List<dynamic> listItem, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).buttonColor,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        child: ListTile(
          title: Text(
            typeList[listItem[index].type],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          subtitle: Text(listItem[index].dateTime.toString() +
              " | " +
              listItem[index].pulse.toString() +
              " bpm"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Bp>> snapshot) {
        if (snapshot.hasData) {
          var listItem = new List.from(snapshot.data.toList().reversed);
          return ListView.builder(
            itemCount: listItem.length,
            itemBuilder: (context, index) {
              return _buildList(context, listItem, index);
            },
          );
        }
        return Container();
      },
    );
  }
}
