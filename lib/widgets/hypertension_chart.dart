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

  // ignore: missing_return
  double bpCalculation(double barWidth) {
    log(this.systolic.toString() + "/" + this.diastolic.toString());
    // hypotension
    if ((this.systolic < 90) && (this.diastolic < 60)) {
      return 0;
    } else if (((this.systolic >= 91) && (this.systolic <= 120)) &&
        (this.diastolic >= 61) &&
        (this.diastolic <= 80)) {
      return 1;
    } else if (((this.systolic >= 121) && (this.systolic <= 140)) ||
        (this.diastolic >= 81) && (this.diastolic <= 90)) {
      // prehypertension
      return 2;
    } else if (((this.systolic >= 141) && (this.systolic <= 160)) ||
        (this.diastolic >= 91) && (this.diastolic <= 100)) {
      // stage 1 hypertension
      return 3;
    } else if ((this.systolic > 160) || (this.diastolic > 100)) {
      // stage 1 hypertension
      return 4;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = (MediaQuery.of(context).size.width / 5) - 4;

    var tick = bpCalculation(barWidth);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        height: 60,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // bar chart
            Row(
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
                  color: Colors.red,
                ),
              ],
            ),
            // tick
            Positioned(
              top: 18,
              left: (barWidth * tick) + ((barWidth / 2) - 8),
              child: FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 22,
                color: Colors.pink,
              ),
            ),
            // label
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  typeList[tick.round()],
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
