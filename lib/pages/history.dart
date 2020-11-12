import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/models/type_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  // static const List<String> typeList = [
  //   "Hypotension",
  //   "Normal",
  //   "Prehypertension",
  //   "Stage 1 Hypertension",
  //   "Stage 2 Hypertension",
  // ];

  static List<TypeItem> typeList = [
    TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
    TypeItem(Colors.lightGreen, "Normal", "91-120", "61-80"),
    TypeItem(Colors.amber, "Prehypertension", "121-140", "81-90"),
    TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
    TypeItem(Colors.red[600], "Stage 2 Hypertension", "> 160", "> 100"),
  ];

  Future<Iterable<Bp>> getData() async {
    // add blood pressure data
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(BpAdapter());
    }
    // hive open box
    Box<Bp> box = await Hive.openBox<Bp>("bloodPressure");
    // box.clear();
    // return box.values.where(
    //     (datetime) => datetime.dateTime.toString().startsWith("2020-11"));
    return box.values;
  }

  _buildList(BuildContext context, List<Bp> listItem, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).buttonColor,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: typeList[(listItem[index].type)].color,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        listItem[index].systolic.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        listItem[index].diastolic.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                typeList[(listItem[index].type)].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(listItem[index]
                      .dateTime
                      .toString()
                      .replaceAll("-", "/")
                      .split(":")
                      .elementAt(0) +
                  ":" +
                  listItem[index].dateTime.toString().split(":").elementAt(1) +
                  " | " +
                  listItem[index].pulse.toString() +
                  " bpm"),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Bp>> snapshot) {
        if (snapshot.hasData) {
          List<Bp> listItem = new List.from(snapshot.data.toList().reversed);
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
