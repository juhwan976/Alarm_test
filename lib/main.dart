import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

import 'AlarmSettingPageTest.dart';
import 'ClassStationInfo.dart';
import 'SecondPage.dart';
import 'StationListPage.dart';

String dropdownValue = '검복리마운틴앞' ;
List<String> SIstringList = [];
var stationmap = Map<String, StationInfo>();

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  /*
  Workmanager.initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
  // Periodic task registration
  Workmanager.registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );
   */

  runApp(MyApp());
}

/*
void callbackDispatcher() {
  Workmanager.executeTask(
    (task, inputData) {
      /* */
      return Future.value(true);
    },
  );
}
*/
/*
void notificationInitialize() {
  // initialise the plugin of flutterlocalnotifications.
  FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

  // app_icon needs to be a added as a drawable
  // resource to the Android head project.
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var IOS = new IOSInitializationSettings();

  // initialise settings for both Android and iOS device.
  var settings = new InitializationSettings(android, IOS);
  flip.initialize(settings);
  showNotificationWithDefaultSound(flip);
}

Future showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flip.show(
    0,
    '홈화면 notification',
    'description',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}
 */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Alarm Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool isWork = false;

  Future<String> getData() async {
    List<StationInfo> dump = [];
    List<String> SItemp = [];
    var maptemp = Map<String, StationInfo>();
    http.Response response = await http.get('https://openapi.gg.go.kr/BusStation?Type=json&pSize=10&KEY=1f28ac029b8a452889cbbcb715513122');
    List<dynamic> jsonlist = json.decode(response.body)['BusStation'][1]['row'];
    for(int a=0; a<jsonlist.length; a++){
      StationInfo temp = StationInfo.fromJson(jsonlist[a]);
      log("StationInfo: ${temp.STATION_NM_INFO}");
      dump.add(temp);
      SItemp.add(temp.STATION_NM_INFO);
      maptemp[temp.STATION_NM_INFO] = temp;
    }
    setState(() {
      stationmap = maptemp;
      SIstringList = SItemp;
      dropdownValue = SIstringList[0];
    });
    return response.body;
  }
/*
  Future _dailyAtTimeNotification() async {
    final notiTitle = 'title';
    final notiDesc = 'description';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    var android = AndroidNotificationDetails(
      'id',
      notiTitle,
      notiDesc,
      importance: Importance.max,
      priority: Priority.high,
    );
    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    if (result??true) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannel('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        notiTitle,
        notiDesc,
        _setNotiTime(),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _setNotiTime() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second + 10,
    );

    return scheduledDate;
  }
 */
/*
  void _initSetting() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );
  }
*/
/*
  Future _notification() async {
    final notiTitle = 'Test Title';
    final notiDesc = 'Test Desciption';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    var android = AndroidNotificationDetails(
      'id',
      notiTitle,
      notiDesc,
      importance: Importance.max,
      priority: Priority.high,
    );
    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(
      android: android,
      iOS: ios,
    );

    if (result??true) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannel('id');

      await flutterLocalNotificationsPlugin.show(
        0,
        notiTitle,
        notiDesc,
        detail,
      );
    }
  }
*/

  @override
  initState() {
    super.initState();

    //_initSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SecondPage(),
          /*
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*
                FlatButton(
                  child: Text('백그라운드 작업 중지'),
                  onPressed: () {
                    Workmanager.cancelAll();
                    setState(
                      () {
                        isWork = false;
                      },
                    );
                  },
                ),
                FlatButton(
                  child: Text('백그라운드 작업 시작'),
                  onPressed: (isWork)
                      ? null
                      : () {
                          Workmanager.initialize(
                            // The top level function, aka callbackDispatcher
                            callbackDispatcher,

                            // If enabled it will post a notification whenever
                            // the task is running. Handy for debugging tasks
                            isInDebugMode: true,
                          );
                          // Periodic task registration
                          Workmanager.registerPeriodicTask(
                            "2",

                            //This is the value that will be
                            // returned in the callbackDispatcher
                            "simplePeriodicTask",

                            // When no frequency is provided
                            // the default 15 minutes is set.
                            // Minimum frequency is 15 min.
                            // Android will automatically change
                            // your frequency to 15 min
                            // if you have configured a lower frequency.
                            frequency: Duration(minutes: 15),
                          );

                          setState(
                            () {
                              isWork = true;
                            },
                          );
                        },
                ),
                */
                /*
                FlatButton(
                  child: Text('zonedSchedule을 사용한 알림'),
                  onPressed: _dailyAtTimeNotification,
                ),
                */
                /*
                FlatButton(
                  child: Text('알림 표시'),
                  onPressed: _notification,
                ),
                */
              ],
            ),
          ),
          */
          //AlarmSettingPage(),
          AlarmSettingPageTest(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return StationListPage();
                },
              ),
            );
          }
      ),
    );
  }
}