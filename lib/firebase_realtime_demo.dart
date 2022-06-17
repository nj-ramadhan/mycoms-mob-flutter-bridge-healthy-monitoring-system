import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import './chart_accel.dart';
import './chart_gyro.dart';

class FirebaseRealtimeDemoScreen extends StatefulWidget {
  const FirebaseRealtimeDemoScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseRealtimeDemoScreen> createState() =>
      _FirebaseRealtimeDemoScreen();
}

class _FirebaseRealtimeDemoScreen extends State<FirebaseRealtimeDemoScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  double _dataAccelX = 0.0;
  double _dataAccelY = 0.0;
  double _dataAccelZ = 0.0;

  double _dataGyroX = 0.0;
  double _dataGyroY = 0.0;
  double _dataGyroZ = 0.0;

  late Timer timer;

  var colors = [Colors.red, Colors.orange, Colors.blue, Colors.white];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        readData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer Monitoring'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        const Text("Data Accel X :"),
                        Text("$_dataAccelX",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                      Column(children: [
                        const Text("Data Accel Y :"),
                        Text("$_dataAccelY",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                      Column(children: [
                        const Text("Data Accel Z :"),
                        Text("$_dataAccelZ",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        minWidth: 150,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeChartAccelPage()),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text('Accel Time Graph'),
                      ),
                      MaterialButton(
                        minWidth: 150,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreqChartAccelPage()),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text('Accel Freq Graph'),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        const Text("Data Gyro X :"),
                        Text("$_dataGyroX",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                      Column(children: [
                        const Text("Data Gyro Y :"),
                        Text("$_dataGyroY",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                      Column(children: [
                        const Text("Data Gyro Z :"),
                        Text("$_dataGyroZ",
                            style: TextStyle(
                                color: colors[3],
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ]),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        minWidth: 150,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeChartGyroPage()),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text('Gyro Time Graph'),
                      ),
                      MaterialButton(
                        minWidth: 150,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FreqChartGyroPage()),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Text('Gyro Freq Graph'),
                      ),
                    ]),
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void readData() {
    databaseReference.child("Data").onValue.listen((event) {
      print('Data : ${event.snapshot.value}');
    });
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    // });
    databaseReference.child('Data/AccelX').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelX = data as double;
      _dataAccelX = accelX;
    });

    databaseReference.child('Data/AccelY').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelY = data as double;
      _dataAccelY = accelY;
    });

    databaseReference.child('Data/AccelZ').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelZ = data as double;
      _dataAccelZ = accelZ;
    });

    databaseReference.child('Data/GyroX').onValue.listen((event) {
      final data = event.snapshot.value;
      final gyroX = data as double;
      _dataGyroX = gyroX;
    });

    databaseReference.child('Data/GyroY').onValue.listen((event) {
      final data = event.snapshot.value;
      final gyroY = data as double;
      _dataGyroY = gyroY;
    });

    databaseReference.child('Data/GyroZ').onValue.listen((event) {
      final data = event.snapshot.value;
      final gyroZ = data as double;
      _dataGyroZ = gyroZ;
    });
  }
}
