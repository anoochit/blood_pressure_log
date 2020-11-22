import 'dart:developer';

import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/widgets/donutpiechart.dart';
import 'package:blood_pressure/widgets/simplebarchart.dart';
import 'package:blood_pressure/widgets/stackedarealinechart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:supercharged/supercharged.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Future<Iterable<Bp>> getMonthData() async {
    // add blood pressure data
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(BpAdapter());
    }
    // hive open box
    Box<Bp> box = await Hive.openBox<Bp>("bloodPressure");
    //box.clear();
    return box.values.where(
      (bp) => bp.dateTime.toString().startsWith(
            DateFormat('y-M-').format(DateTime.now()),
          ),
    );
  }

  Widget buildSumaryStats(List<Bp> listItem) {
    // systolic value
    var systolicValueAverage = listItem.averageBy((bp) => bp.systolic).floor();

    final List<BPChartData> dataSystolic = [
      BPChartData("0", systolicValueAverage,
          charts.ColorUtil.fromDartColor(Colors.red)),
      BPChartData("1", 200 - systolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.red.shade100))
    ];

    var seriesDataSystolic = [
      new charts.Series<BPChartData, dynamic>(
        id: 'Sales',
        domainFn: (BPChartData bpChartData, _) => bpChartData.id,
        measureFn: (BPChartData bpChartData, _) => bpChartData.value,
        colorFn: (BPChartData bpChartData, _) => bpChartData.color,
        data: dataSystolic,
      )
    ];

    // diastolic value
    var diastolicValueAverage =
        listItem.averageBy((bp) => bp.diastolic).floor();

    final List<BPChartData> dataDiastolic = [
      BPChartData("0", diastolicValueAverage,
          charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      BPChartData("1", 200 - diastolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.lightGreen.shade100))
    ];

    var seriesDataDiastolic = [
      new charts.Series<BPChartData, dynamic>(
        id: 'Sales',
        domainFn: (BPChartData bpChartData, _) => bpChartData.id,
        measureFn: (BPChartData bpChartData, _) => bpChartData.value,
        colorFn: (BPChartData bpChartData, _) => bpChartData.color,
        data: dataDiastolic,
      )
    ];

    // pulse value
    var pulseValueAverage = listItem.averageBy((bp) => bp.pulse).floor();

    final List<BPChartData> dataPulse = [
      BPChartData("0", pulseValueAverage,
          charts.ColorUtil.fromDartColor(Colors.lightBlue)),
      BPChartData("1", 200 - pulseValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.blue.shade100))
    ];

    var seriesDataPulse = [
      new charts.Series<BPChartData, dynamic>(
        id: 'Sales',
        domainFn: (BPChartData bpChartData, _) => bpChartData.id,
        measureFn: (BPChartData bpChartData, _) => bpChartData.value,
        colorFn: (BPChartData bpChartData, _) => bpChartData.color,
        data: dataPulse,
      )
    ];

    return Flex(
      direction: Axis.horizontal,
      children: [
        donutChartWidget(
          seriesDataSystolic,
          systolicValueAverage,
          Colors.red,
          "SYS",
        ),
        donutChartWidget(
          seriesDataDiastolic,
          diastolicValueAverage,
          Colors.green,
          "DIA",
        ),
        donutChartWidget(
          seriesDataPulse,
          pulseValueAverage,
          Colors.blue,
          "PUL",
        ),
      ],
    );
  }

  Widget donutChartWidget(List<charts.Series<BPChartData, dynamic>> seriesData,
      int value, Color colorData, String title) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 3),
      height: (MediaQuery.of(context).size.width / 3),
      child: Stack(
        children: [
          DonutPieChart(seriesData),
          Container(
            padding: EdgeInsets.only(top: 32),
            alignment: Alignment.topCenter,
            child: Text(
              "AVG",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeStats(List<Bp> listItem) {
    var total = listItem.length;

    var type0 = ((listItem.count((n) => n.type == 0) / total) * 100).toInt();
    var type1 = ((listItem.count((n) => n.type == 1) / total) * 100).toInt();
    var type2 = ((listItem.count((n) => n.type == 2) / total) * 100).toInt();
    var type3 = ((listItem.count((n) => n.type == 3) / total) * 100).toInt();
    var type4 = ((listItem.count((n) => n.type == 4) / total) * 100).toInt();

    // var type0 = (listItem.count((n) => n.type == 0));
    // var type1 = (listItem.count((n) => n.type == 1));
    // var type2 = (listItem.count((n) => n.type == 2));
    // var type3 = (listItem.count((n) => n.type == 3));
    // var type4 = (listItem.count((n) => n.type == 4));

    final List<BPChartData> dataType = [
      BPChartData(
          "Hypo", type0, charts.ColorUtil.fromDartColor(Colors.lightBlue)),
      BPChartData(
          "Normal", type1, charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      BPChartData("Pre", type2, charts.ColorUtil.fromDartColor(Colors.amber)),
      BPChartData(
          "State1", type3, charts.ColorUtil.fromDartColor(Colors.orange)),
      BPChartData("State2", type4, charts.ColorUtil.fromDartColor(Colors.red))
    ];

    var seriesDataType = [
      new charts.Series<BPChartData, String>(
        id: 'Sales',
        domainFn: (BPChartData bpChartData, _) => bpChartData.id.toString(),
        measureFn: (BPChartData bpChartData, _) => bpChartData.value,
        colorFn: (BPChartData bpChartData, _) => bpChartData.color,
        data: dataType,
        labelAccessorFn: (BPChartData bpChartData, _) =>
            '${bpChartData.value.toString()}\%',
      )
    ];

    return Builder(
      builder: (BuildContext context) {
        return SimpleBarChart(seriesDataType, animate: true);
      },
    );
  }

  Widget buildTimeseriesStats(List<Bp> listItem) {
    // get days in month
    var numMonth = DateFormat('M').format(DateTime.now()).toInt();
    var numYear = DateFormat('y').format(DateTime.now()).toInt();

    // current day
    //var totalDay = dateUtility.daysInMonth(numMonth, numYear);
    var totalDay = DateFormat('d').format(DateTime.now()).toInt();

    // list all data in hive
    List<BPChartDataInt> timeSeriesSystolic = [];
    List<BPChartDataInt> timeSeriesDiastolic = [];

    for (int day = 1; day <= totalDay; day++) {
      // check data in day and calculate its average
      String dateFormat = DateFormat('y-M-dd ')
          .format(DateTime(numYear, numMonth, day))
          .toString();

      List<dynamic> valueSysDia = getAverageDataFromDay(dateFormat, listItem);

      timeSeriesSystolic.add(BPChartDataInt(day, valueSysDia[0].toInt(),
          charts.ColorUtil.fromDartColor(Colors.redAccent)));

      timeSeriesDiastolic.add(BPChartDataInt(day, valueSysDia[1].toInt(),
          charts.ColorUtil.fromDartColor(Colors.lightGreen)));
    }

    List<charts.Series<BPChartDataInt, int>> seriesDataType = [
      new charts.Series<BPChartDataInt, int>(
        id: 'Dia',
        domainFn: (BPChartDataInt bpChartData, _) => bpChartData.id,
        measureFn: (BPChartDataInt bpChartData, _) => bpChartData.value,
        colorFn: (BPChartDataInt bpChartData, _) => bpChartData.color,
        data: timeSeriesDiastolic,
      ),
      new charts.Series<BPChartDataInt, int>(
        id: 'Sys',
        domainFn: (BPChartDataInt bpChartData, _) => bpChartData.id,
        measureFn: (BPChartDataInt bpChartData, _) => bpChartData.value,
        colorFn: (BPChartDataInt bpChartData, _) => bpChartData.color,
        data: timeSeriesSystolic,
      ),
    ];

    return StackedAreaLineChart(seriesDataType, animate: true);
  }

  List<dynamic> getAverageDataFromDay(String dateString, List<Bp> listItem) {
    List<int> listOfDiaValue = [];
    List<int> listOfSysValue = [];

    listItem.forEach((element) {
      if (element.dateTime.toString().startsWith(dateString)) {
        listOfSysValue.add(element.systolic);
        listOfDiaValue.add(element.diastolic);
      } else {
        listOfSysValue.add(0);
        listOfDiaValue.add(0);
      }
    });

    log(dateString + "->" + listOfSysValue.max().toString());

    return [(listOfSysValue.max()), (listOfDiaValue.max())];
  }

  // TODO : implement filter for previous statistics

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: getMonthData(),
        builder: (BuildContext context, AsyncSnapshot<Iterable<Bp>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length != 0) {
              List<Bp> listItem = new List.from(snapshot.data.toList());
              return Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 3,
                    child: buildSumaryStats(listItem),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height / 3.2),
                      child: buildTimeseriesStats(listItem)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height / 3.2),
                    child: buildTypeStats(listItem),
                  ),
                ],
              );
            } else {
              return Container(
                  alignment: Alignment.topCenter, child: Text("No Data"));
            }
          }
          return Container();
        },
      ),
    );
  }
}

class BPChartData {
  final String id;
  final int value;
  final charts.Color color;

  BPChartData(this.id, this.value, this.color);
}

class BPChartDataInt {
  final int id;
  final int value;
  final charts.Color color;

  BPChartDataInt(this.id, this.value, this.color);
}
