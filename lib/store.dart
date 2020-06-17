import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';
import 'package:plus_minus_flutter/models/activity.dart';

class ConfigStore with ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  Activity activity;

  String selectedDateToString() {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd', "ja_JP");
    var formatted = formatter.format(selectedDate); // DateからString
    return formatted;
  }
  setDate(DateTime date) {
    selectedDate = date;
    // TODO: 本来はちゃんとwhereで取得
    activity = Activity(id: 1, weight: 54.3, createdAt: date);
    notifyListeners();
  }
}