import 'dart:developer';

import 'package:blood_pressure/models/bp.dart';
import 'package:blood_pressure/widgets/chart_donut.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
    return box.values.where((bp) => bp.dateTime
        .toString()
        .startsWith(DateFormat('y-M').format(DateTime.now())));
  }

  Widget buildSumaryStats(List<Bp> listItem) {
    var systolicValue = 0;
    var diastolicValue = 0;
    var pulseValue = 0;

    listItem.forEach((element) {
      systolicValue = systolicValue + element.systolic;
      diastolicValue = diastolicValue + element.diastolic;
      pulseValue = pulseValue + element.pulse;
    });

    var systolicValueAverage = (systolicValue / listItem.length);

    final List<BPChartData> dataSystolic = [
      BPChartData(0, systolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.red)),
      BPChartData(1, 200 - systolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.grey.shade300))
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

    var diastolicValueAverage = (diastolicValue / listItem.length);

    final List<BPChartData> dataDiastolic = [
      BPChartData(0, diastolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.green)),
      BPChartData(1, 200 - diastolicValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.grey.shade300))
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

    var pulseValueAverage = (pulseValue / listItem.length);

    final List<BPChartData> dataPulse = [
      BPChartData(0, pulseValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.blue)),
      BPChartData(1, 200 - pulseValueAverage.floor(),
          charts.ColorUtil.fromDartColor(Colors.grey.shade300))
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

    return Row(
      children: [
        donutChartWidget(seriesDataSystolic, systolicValueAverage.floor(),
            Colors.red, "SYS"),
        donutChartWidget(seriesDataDiastolic, diastolicValueAverage.floor(),
            Colors.green, "DIA"),
        donutChartWidget(
            seriesDataPulse, pulseValueAverage.floor(), Colors.blue, "PLS"),
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
            padding: EdgeInsets.only(top: 34),
            alignment: Alignment.topCenter,
            child: Text(
              "AVG",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 34),
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: colorData),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getMonthData(),
          builder:
              (BuildContext context, AsyncSnapshot<Iterable<Bp>> snapshot) {
            if (snapshot.hasData) {
              List<Bp> listItem = new List.from(snapshot.data.toList());
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 3,
                  child: buildSumaryStats(listItem));
            }
            return Container();
          },
        ),
      ],
    );
  }
}

class BPChartData {
  final int id;
  final int value;
  final charts.Color color;

  BPChartData(this.id, this.value, this.color);
}
