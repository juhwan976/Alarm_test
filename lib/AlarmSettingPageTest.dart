import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'AlarmInfo.dart';
import 'AlarmPage.dart';
import 'AlarmSettingDetailPage.dart';

class AlarmSettingPageTest extends StatefulWidget {
  const AlarmSettingPageTest({Key key}) : super(key: key);

  _AlarmSettingPageTestState createState() => _AlarmSettingPageTestState();
}

class _AlarmSettingPageTestState extends State<AlarmSettingPageTest> {
  Timer _alarm;

  List<AlarmInfo> _alarmList = [
    AlarmInfo(
      busNum: 8,
      arrival: DateTime.now().add(Duration(minutes: 2, seconds: 30)),
      useHour: true,
      useMinute: true,
      beforeHour: 0,
      beforeMinute: 0,
      enable: false,
      alarmAtNext: false,
    ),
  ];

  void _notificationInitialize(AlarmInfo _alarmInfo) {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: iOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip, _alarmInfo);
  }

  Future _showNotificationWithDefaultSound(flip, AlarmInfo _alarmInfo) async {
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    final result = await flip
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (result) {
      flip
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannel('id');
      await flip.show(
        0,
        '버스 알림',
        '버스도착 ' +
            ((_alarmInfo.useHour)
                ? _alarmInfo.beforeHour.toString() + ' 시간 '
                : '') +
            ((_alarmInfo.useMinute)
                ? _alarmInfo.beforeMinute.toString() + ' 분 '
                : '') +
            '전입니다.',
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }
  }

  Widget _buildPage() {
    return Container(
      child: ListView.builder(
        itemCount: _alarmList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (_alarmList.length == 0) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('버스를 즐겨찾기 등록하면'),
                  Text('알람기능을 사용할 수 있어요.'),
                ],
              ),
            );
          } else {
            if (index == 0) {
              return Container(
                child: Text(
                  '총 ${_alarmList.length} 개',
                ),
              );
            } else {
              return Container(
                height: 80,
                color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            _alarmList.elementAt(index - 1).busNum.toString() +
                                ' 번',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final AlarmInfo result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AlarmSettingDetailPage(
                                  alarmInfo: _alarmList.elementAt(index - 1),
                                );
                              },
                            ),
                          );

                          if (result == null) {
                            /* do nothing */
                          } else {
                            setState(
                              () {
                                _alarmList[index - 1] = result;
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        VerticalDivider(),
                        CupertinoSwitch(
                          value: _alarmList.elementAt(index - 1).enable,
                          onChanged: (bool value) {
                            _alarmList.elementAt(index - 1).enable = value;

                            if (_alarmList.elementAt(index - 1).enable) {
                              _alarmList.elementAt(index - 1).alarmAtNext =
                                  false;
                              _alarmList.elementAt(index - 1).arrival =
                                  DateTime.now()
                                      .add(Duration(minutes: 2, seconds: 30));
                            } else {}

                            //_notificationInitialize(_alarmList.elementAt(index - 1));

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  _alarmCallback() {
    bool flag = false;
    print(DateTime.now());
    for (int index = 0; index < _alarmList.length; index++) {
      DateTime _now = DateTime.now();
      DateTime _target = _alarmList.elementAt(index).arrival.subtract(
            Duration(
              hours: _alarmList.elementAt(index).beforeHour,
              minutes: _alarmList.elementAt(index).beforeMinute,
            ),
          );
      print(_target);

      if (_alarmList.elementAt(index).enable &&
          _target.year == _now.year &&
          _target.month == _now.month &&
          _target.day == _now.day &&
          _target.hour == _now.hour &&
          _target.minute <= _now.minute &&
          !_alarmList.elementAt(index).alarmAtNext &&
          !flag) {
        flag = true;
        _alarmList.elementAt(index).alarmAtNext = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AlarmPage(alarmInfo: _alarmList.elementAt(index));
            },
          ),
        );
        _notificationInitialize(_alarmList.elementAt(index));
      } else if (flag) {
        break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _alarm = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        _alarmCallback();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _alarm?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알람 설정 관리'),
        centerTitle: true,
      ),
      body: _buildPage(),
    );
  }
}
