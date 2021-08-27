import 'dart:developer';

import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/models/type_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static List<TypeItem> typeList = [
    TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
    TypeItem(Colors.lightGreen, "Normal", "91-120", "61-80"),
    TypeItem(Colors.amber, "Prehypertension", "121-140", "81-90"),
    TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
    TypeItem(Colors.red[600], "Stage 2 Hypertension", "> 160", "> 100"),
  ];

  DateTime _dateTime;
  int _typeFilter;

  Future<Iterable<Bp>> getData(int filter, DateTime dateTime) async {
    // add blood pressure data
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(BpAdapter());
    }
    // hive open box
    Box<Bp> box = await Hive.openBox<Bp>("bloodPressure");
    //box.clear();

    // let's check filter value
    if (_dateTime == null) {
      _dateTime = DateTime.now();
    }

    // return filter value
    if (filter != null) {
      return box.values.where((bp) => bp.dateTime.toString().startsWith(DateFormat('y-MM-').format(DateTime.now()))).where((bp) => bp.type == filter);
    } else {
      return box.values.where((bp) => bp.dateTime.toString().startsWith(DateFormat('y-MM-').format(DateTime.now())));
    }
  }

  Widget _buildList(BuildContext context, List<Bp> listItem, int index) {
    return Slidable(
        key: ValueKey(index),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              // recreate key from dateTime
              var _key = DateTime(
                      int.parse(DateFormat('yyy').format(listItem[index].dateTime)),
                      int.parse(DateFormat('MM').format(listItem[index].dateTime)),
                      int.parse(DateFormat('dd').format(listItem[index].dateTime)),
                      int.parse(DateFormat('HH').format(listItem[index].dateTime)),
                      int.parse(DateFormat('mm').format(listItem[index].dateTime)))
                  .microsecondsSinceEpoch
                  .toString();

              log('delete at key -> ' + _key);
              // add blood pressure data
              if (Hive.isAdapterRegistered(1) == false) {
                Hive.registerAdapter(BpAdapter());
              }
              // hive open box
              setState(() {
                Hive.openBox<Bp>("bloodPressure").then((box) {
                  box.delete(_key).then((value) {
                    Fluttertoast.showToast(
                      msg: "Deleted",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                    );
                  });
                });
              });
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Container(
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
                            thickness: 1.2,
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
              Column(
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
                  Text(DateFormat('d/MM/y H:mm').format(listItem[index].dateTime) + " | " + listItem[index].pulse.toString() + " bpm"),
                ],
              ),
            ]),
          ),
        ));
  }

  // TODO : implement filter for previous history data

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(_typeFilter, _dateTime),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Bp>> snapshot) {
        if (snapshot.hasData) {
          List<Bp> listItem = new List.from(snapshot.data.toList().reversed);
          if (listItem.length > 0) {
            return ListView.builder(
              itemCount: listItem.length,
              itemBuilder: (context, index) {
                return _buildList(context, listItem, index);
              },
            );
          } else {
            return Container(alignment: Alignment.topCenter, child: Text("No Data"));
          }
        }
        return Container();
      },
    );
  }
}
