import 'dart:developer';
import 'dart:ui';

import 'package:blood_pressure/models/type_item.dart';
import 'package:blood_pressure/style/style.dart';
import 'package:blood_pressure/widgets/hypertension_chart.dart';
import 'package:blood_pressure/widgets/type_item.dart';
import 'package:flutter/material.dart';
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
    TypeItem(Colors.red, "Stage 2 Hypertension", "> 160", "> 100"),
    TypeItem(Colors.orange, "Stage 1 Hypertension", "141-160", "91-100"),
    TypeItem(Colors.amber, "Prehypertension", "121-140", "81-90"),
    TypeItem(Colors.lightGreen, "Normal", "91-120", "61-80"),
    TypeItem(Colors.lightBlue, "Hypotension", "< 90", "< 60"),
  ];

  @override
  Widget build(BuildContext context) {
    // let's make default values
    if ((_timeValue == null) || (_dateValue == null)) {
      _timeValue = DateFormat.Hm().format(new DateTime.now());
      _dateValue = DateFormat.yMd().format(new DateTime.now());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HypertensionChart(_systolic, _diastolic),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).buttonColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: (MediaQuery.of(context).size.height * 0.68),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  // number picker
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Systolic", style: kTitleBold),
                            Text("mmHg", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _systolic,
                              minValue: 20,
                              maxValue: 200,
                              infiniteLoop: true,
                              onChanged: (systolic) {
                                setState(() {
                                  _systolic = systolic;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Diastolic", style: kTitleBold),
                            Text("mmHg", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _diastolic,
                              minValue: 20,
                              maxValue: 200,
                              infiniteLoop: true,
                              onChanged: (diastolic) {
                                setState(() {
                                  _diastolic = diastolic;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Text("Pulse", style: kTitleBold),
                            Text("bpm", style: kTitleLight),
                            SizedBox(height: 8),
                            NumberPicker.integer(
                              initialValue: _pulse,
                              minValue: 20,
                              maxValue: 200,
                              infiniteLoop: true,
                              onChanged: (pluse) {
                                setState(() {
                                  _pulse = pluse;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // divider
                  Divider(thickness: 1.0),
                  // options
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text((_dateValue != null) ? _dateValue : "Today")
                            ],
                          ),
                          onTap: () {
                            log("open date picker");
                          },
                        ),
                        InkWell(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text((_timeValue != null) ? _timeValue : "Today")
                            ],
                          ),
                          onTap: () {
                            log("open time picker");
                          },
                        ),
                        InkWell(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Icon(
                                Icons.label_outline,
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                              SizedBox(
                                width: 8.0,
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
                  // add button
                  MaterialButton(
                    color: kButtonColorAccent,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  // divider
                  Divider(thickness: 1.0),
                  // table header
                  Row(
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
    );
  }
}
