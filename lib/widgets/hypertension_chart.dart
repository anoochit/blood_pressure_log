import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HypertensionChart extends StatelessWidget {
  final int systolic;
  final int diastolic;

  static const List<String> typeList = [
    "Hypotension",
    "Normal",
    "Prehypertension",
    "Stage 1 Hypertension",
    "Stage 2 Hypertension",
  ];

  const HypertensionChart(
    this.systolic,
    this.diastolic, {
    Key key,
  }) : super(key: key);

  double bpCalculation(double barWidth) {
    log(this.systolic.toString() + "/" + this.diastolic.toString());
    if ((this.systolic <= 90) && (this.diastolic <= 60)) {
      log("status -> 0");
      return 0;
    } else if ((this.systolic <= 120) && (this.diastolic <= 80)) {
      log("status -> 1");
      return 1;
    } else if ((this.systolic <= 140) && (this.diastolic <= 90)) {
      log("status -> 2");
      return 2;
    } else if ((this.systolic <= 160) && (this.diastolic <= 100)) {
      log("status -> 3");
      return 3;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = (MediaQuery.of(context).size.width / 5) - 4;

    var tick = bpCalculation(barWidth);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Container(
            height: 28,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // bar chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: barWidth,
                      height: 12,
                      color: Colors.lightBlue,
                    ),
                    Container(
                      width: barWidth,
                      height: 12,
                      color: Colors.lightGreen,
                    ),
                    Container(
                      width: barWidth,
                      height: 12,
                      color: Colors.amber,
                    ),
                    Container(
                      width: barWidth,
                      height: 12,
                      color: Colors.orange,
                    ),
                    Container(
                      width: barWidth,
                      height: 12,
                      color: Colors.red[600],
                    ),
                  ],
                ),
                // tick
                Positioned(
                  top: 2,
                  left: (barWidth * tick) + ((barWidth / 2) - 8),
                  child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    size: 22,
                    color: Colors.pink[300],
                  ),
                ),
              ],
            ),
          ),
          Text(
            typeList[tick.round()],
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
