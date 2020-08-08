import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testbackgroundjob/file_manager.dart';
import 'package:testbackgroundjob/notification_manager.dart';
import 'package:workmanager/workmanager.dart';
import 'received_notification.dart';

FileManager fileManager = new FileManager();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);

  notificationManager();

  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    await fileManager.writeCounter();
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Background Job'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "When Press Start Task background task initialize and increase value at every 15 min.",
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                _showNotification();
              },
              child: Text(
                "Get Notification",
                style: TextStyle(color: Colors.white),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () {
                Workmanager.cancelAll();
                Workmanager.registerPeriodicTask("2", "Task",
                    initialDelay: Duration(seconds: 0));
              },
              child: Text(
                "Start Task",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNotification() async {
    var value = await fileManager.readCounter.call().then((value) => value);
    print("value~-=-~>$value");
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '01', 'count', 'show count',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Count', "value~~~>$value", platformChannelSpecifics,
        payload: 'item x');
  }
}
