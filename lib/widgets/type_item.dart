import 'package:flutter/material.dart';

class TypeItemWidget extends StatelessWidget {
  final Color color;
  final String text;
  final String sysval;
  final String diaval;
  final int bold;
  final int index;

  const TypeItemWidget(
      {Key key,
      this.color,
      this.text,
      this.sysval,
      this.diaval,
      this.bold,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: this.color,
                      borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.5 - 28,
                    child: Center(
                        child: Text(
                      this.text,
                      style: TextStyle(
                          fontWeight: (bold == (4 - index))
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ))),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(this.sysval)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(child: Text(this.diaval)),
          ),
        ],
      ),
    );
  }
}
