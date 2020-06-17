import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:plus_minus_flutter/app_color.dart';
import 'package:plus_minus_flutter/models/activity.dart';
import 'package:plus_minus_flutter/store.dart';

class WeightGraph extends StatefulWidget {
  @override
  WeightGraphState createState() => WeightGraphState();
}

class WeightGraphState extends State<WeightGraph> {
  // final yLineLength = 200.0;

  final start = 70.0;
  final goal = 40.3;
  final data = [54.3, 58.4, 53.2, 4.4, 62.1];

  final dateLit = [DateTime.now()];

  double yLineLength(BuildContext contex) {
    return MediaQuery.of(context).size.height / 3.5;
  }

  double maxOfGraph() {
    // TODO: 本来はsqlでmaxを取得する
    const baseNumber = 10;
    double max = data.reduce((curr, next) => curr > next ? curr : next);
    max = [max, start, goal].reduce((curr, next) => curr > next ? curr : next);
    return ((max / baseNumber).ceil() * baseNumber).toDouble() + 10;
  }

  double minOfGraph() {
    const baseNumber = 10;
    double min = data.reduce((curr, next) => curr < next ? curr : next);
    min = [min, start, goal].reduce((curr, next) => curr < next ? curr : next);
    return ((min / baseNumber).floor() * baseNumber).toDouble() - 10;
  }

  double topOfStartHeight() {
    return 50.0;
  }

  double topOfGoalHeight() {
    return 150.0;
  }

  double topByWeight(weight, context) {
    double interval = maxOfGraph() - minOfGraph();
    double under = weight - minOfGraph();
    return yLineLength(context) - (yLineLength(context) * under / interval);
  }

  bool isSelectedDate(DateTime selectedDate, DateTime date) {
    return selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;
  }

  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            height: 0.4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 0.4,
              color: Colors.grey[300],
            ),
          ),

          // 開始
          Positioned(
            top: topByWeight(start, context),
            left: 0.0,
            height: 20.0,
            child: Row(
              children: <Widget>[
                Dash(
                  length: MediaQuery.of(context).size.width - 80,
                  dashThickness: 0.5,
                ),
                Container(
                  child: Text("開始", style: TextStyle(color: Colors.white)),
                  alignment: Alignment.center,
                  height: 25,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          ),

          // 目標
          Positioned(
            top: topByWeight(goal, context),
            left: 0.0,
            height: 20.0,
            child: Row(
              children: <Widget>[
                Dash(
                  length: MediaQuery.of(context).size.width - 80,
                  dashThickness: 0.5,
                  dashColor: AppColor.main,
                ),
                Container(
                  child: Text("目標", style: TextStyle(color: Colors.white)),
                  alignment: Alignment.center,
                  height: 25,
                  width: 45,
                  decoration: BoxDecoration(
                    color: AppColor.main,
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          ),

          // 下の線
          Positioned(
            top: yLineLength(context),
            left: 0.0,
            height: 0.4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 0.4,
              color: Colors.grey[300],
            ),
          ),

          // データ
          Container(
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (index >= dateLit.length) {
                  dateLit.add(DateTime.now().add(Duration(days: 1 - index)));
                }
                if (index == 0) {
                  return Container(
                    width: 30,
                  );
                } else {
                  return _perLine(context, 60.0, dateLit[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _perLine(BuildContext context, double weight, DateTime date) {
    initializeDateFormatting("ja_JP");
    final formatter = new DateFormat('dd(E)', "ja_JP");

    Activity activity = Activity.findbyDate(date);
    DateTime selectedDate = Provider.of<ConfigStore>(context).selectedDate;

    return Container(
      width: 60,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Provider.of<ConfigStore>(context, listen: false).setDate(date);
            },
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: 5,
                          height: topByWeight(activity.weight, context),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: activity.inDay(date)
                                ? AppColor.main
                                : Colors.white.withOpacity(0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // タップ用に太い線を入れる
                        Container(
                          width: 60,
                          height: yLineLength(context),
                          color: Colors.white.withOpacity(0),
                        ),
                        // 選択されている時のオレンジの太い線
                        Container(
                          width: 30,
                          height: yLineLength(context),
                          color: isSelectedDate(selectedDate, date)
                              ? AppColor.main.withOpacity(0.2)
                              : AppColor.main.withOpacity(0),
                        ),
                        Container(
                          width: 0.4,
                          height: yLineLength(context),
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(formatter.format(date)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
