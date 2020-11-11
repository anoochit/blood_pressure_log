import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HypertensionChart extends StatelessWidget {
  final int systolic;
  final int diastolic;

  const HypertensionChart(
    this.systolic,
    this.diastolic, {
    Key key,
  }) : super(key: key);

  // ignore: missing_return
  double bpCalculation(double barWidth) {
    log(this.systolic.toString() + "/" + this.diastolic.toString());
    // normal
    if (((this.systolic >= 91) && (this.systolic <= 120)) ||
        (this.diastolic >= 61) && (this.diastolic <= 80)) {
      return (barWidth * 1) + 30;
    } else if (((this.systolic >= 121) && (this.systolic <= 140)) &&
        (this.diastolic >= 81) &&
        (this.diastolic <= 90)) {
      // prehypertension
      return (barWidth * 2) + 30;
    } else if (((this.systolic >= 141) || (this.systolic <= 160)) &&
        (this.diastolic >= 91) &&
        (this.diastolic <= 100)) {
      // stage 1 hypertension
      return (barWidth * 3) + 30;
    } else if ((this.systolic > 160) || (this.diastolic > 100)) {
      // stage 1 hypertension
      return (barWidth * 4) + 30;
    } else if ((this.systolic < 90) || (this.diastolic < 60)) {
      return (barWidth * 0) + 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = (MediaQuery.of(context).size.width / 5) - 4;

    var tick = bpCalculation(barWidth);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 22,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // bar chart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: barWidth,
                  height: 10,
                  color: Colors.lightBlue,
                ),
                Container(
                  width: barWidth,
                  height: 10,
                  color: Colors.green,
                ),
                Container(
                  width: barWidth,
                  height: 10,
                  color: Colors.amber,
                ),
                Container(
                  width: barWidth,
                  height: 10,
                  color: Colors.orange,
                ),
                Container(
                  width: barWidth,
                  height: 10,
                  color: Colors.red,
                ),
              ],
            ),
            // tick
            Positioned(
              left: tick,
              child: FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 22,
                color: Colors.pink,
              ),
            )
          ],
        ),
      ),
    );
  }
}
