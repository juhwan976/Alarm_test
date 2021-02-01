import 'package:flutter/foundation.dart';

class AlarmInfo {
  bool useHour;
  bool useMinute;
  int beforeHour;
  int beforeMinute;

  AlarmInfo({
    @required this.useHour,
    @required this.useMinute,
    @required this.beforeHour,
    @required this.beforeMinute,
  });
}
