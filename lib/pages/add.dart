import 'dart:developer';
import 'dart:ui';

import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/models/type_item.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:blood_pressure/widgets/hypertension_chart.dart';
import 'package:blood_pressure/widgets/type_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  //  blood pressure value
  int _systolic = 110;
  int _diastolic = 80;
  int _pulse = 110;

  // date time value
  String _dateValue;
  String _timeValue;

  // blood pressure type
  List<TypeItem> typeList = [
    TypeItem(Colors.red[600], "Stage 2 Hypertension", "> 160", "> 100"),
    TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
    TypeItem(Colors.amber, "Prehypertension", "121-140", "81-90"),
    TypeItem(Colors.lightGreen, "Normal", "91-120", "61-80"),
    TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
  ];

  int bpCalculation(int systolic, int diastolic) {
    log(_systolic.toString() + "/" + _diastolic.toString());
    // hypotension
    if ((_systolic < 90) || (_diastolic < 60)) {
      return 0;
    } else if (((_systolic >= 91) && (_systolic <= 120)) ||
        (_diastolic >= 61) && (_diastolic <= 80)) {
      return 1;
    } else if (((_systolic >= 121) && (_systolic <= 140)) ||
        (_diastolic >= 81) && (_diastolic <= 90)) {
      // prehypertension
      return 2;
    } else if (((_systolic >= 141) && (_systolic <= 160)) ||
        (_diastolic >= 91) && (_diastolic <= 100)) {
      // stage 1 hypertension
      return 3;
    } else if ((_systolic > 160) || (_diastolic > 100)) {
      // stage 2 hypertension
      return 4;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(DateFormat('d/M/y').format(new DateTime.now()));
    log(DateFormat('H:mm').format(new DateTime.now()));
    // let's make default values
    if ((_timeValue == null) || (_dateValue == null)) {
      _timeValue = DateFormat('H:mm').format(new DateTime.now());
      _dateValue = DateFormat('d/M/y').format(new DateTime.now());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            HypertensionChart(_systolic, _diastolic),
            Container(
              height: (MediaQuery.of(context).size.height * 0.66),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).buttonColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    // number picker
                    Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Systolic", style: kTitleBold),
                            Text("mmHg", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _systolic,
                              minValue: 20,
                              maxValue: 200,
                              onChanged: (systolic) {
                                setState(() {
                                  _systolic = systolic;
                                });
                              },
                            ),
                          ],
                        ),
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Diastolic", style: kTitleBold),
                            Text("mmHg", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _diastolic,
                              minValue: 20,
                              maxValue: 200,
                              onChanged: (diastolic) {
                                setState(() {
                                  _diastolic = diastolic;
                                });
                              },
                            ),
                          ],
                        ),
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Pulse", style: kTitleBold),
                            Text("bpm", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _pulse,
                              minValue: 20,
                              maxValue: 200,
                              onChanged: (pluse) {
                                setState(() {
                                  _pulse = pluse;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    // divider
                    Divider(thickness: 1.0),
                    // options
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(
                                    Icons.today,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text((_dateValue != null)
                                      ? _dateValue
                                      : "Today")
                                ],
                              ),
                              onTap: () {
                                log("open date picker" + _dateValue.toString());

                                showDatePicker(
                                  context: context,
                                  //initialDate: DateTime.now(),
                                  initialDate: DateTime(
                                    int.parse(
                                        _dateValue.split("/").elementAt(2)),
                                    int.parse(
                                        _dateValue.split("/").elementAt(1)),
                                    int.parse(
                                        _dateValue.split("/").elementAt(0)),
                                    0,
                                  ),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                  initialDatePickerMode: DatePickerMode.day,
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _dateValue = value.day.toString() +
                                          "/" +
                                          value.month.toString() +
                                          "/" +
                                          value.year.toString();
                                    } else {
                                      _dateValue = DateFormat.yMd()
                                          .format(new DateTime.now());
                                    }
                                    log(_dateValue);
                                  });
                                });
                              },
                            ),
                            InkWell(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text((_timeValue != null)
                                      ? _timeValue
                                      : "Today")
                                ],
                              ),
                              onTap: () {
                                log("open time picker");
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.dial,
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child,
                                    );
                                  },
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _timeValue = DateFormat('H:mm').format(
                                          DateTime(2020, 01, 01, value.hour,
                                              value.minute));
                                    } else {
                                      _timeValue = DateFormat('H:mm')
                                          .format(DateTime.now());
                                    }
                                  });
                                });
                              },
                            ),
                            InkWell(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(
                                    Icons.label_outline,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text("Tags")
                                ],
                              ),
                              onTap: () {
                                log("open tag dialog");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    // add button
                    MaterialButton(
                      color: kButtonColorAccent,
                      minWidth: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        'ADD',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // add blood pressure data
                        if (Hive.isAdapterRegistered(1) == false) {
                          Hive.registerAdapter(BpAdapter());
                        }
                        // hive open box
                        Hive.openBox<Bp>("bloodPressure").then((box) {
                          var _key =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          var _dateTime = DateTime(
                              int.parse(_dateValue.split("/").elementAt(2)),
                              int.parse(_dateValue.split("/").elementAt(1)),
                              int.parse(_dateValue.split("/").elementAt(0)),
                              int.parse(_timeValue.split(":").elementAt(0)),
                              int.parse(_timeValue.split(":").elementAt(1)));
                          // save data
                          box
                              .put(
                                  _key,
                                  Bp(_dateTime, _systolic, _diastolic, _pulse,
                                      bpCalculation(_systolic, _diastolic)))
                              .then((value) {
                            Fluttertoast.showToast(
                              msg: "Added",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                            );
                          }).catchError((onError) {
                            Fluttertoast.showToast(
                              msg: "Error",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                            );
                          });
                        });
                      },
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    // divider
                    Divider(thickness: 1.0),
                    // table header
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: Text("TYPE"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                            child: Text("SYS"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Center(
                            child: Text("DIA"),
                          ),
                        ),
                      ],
                    ),
                    // divider
                    Divider(thickness: 1.0),
                    // table rows
                    for (int index = 0; index < typeList.length; index++)
                      TypeItemWidget(
                        color: typeList[index].color,
                        text: typeList[index].title,
                        sysval: typeList[index].sysval,
                        diaval: typeList[index].diaval,
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
