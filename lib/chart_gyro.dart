import 'dart:async';
import 'dart:math';

import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.ref();
double _dataGyroX = 0.0;
double _dataGyroY = 0.0;
double _dataGyroZ = 0.0;

class TimeChartGyroPage extends StatefulWidget {
  const TimeChartGyroPage({Key? key}) : super(key: key);

  @override
  _TimeChartGyroPage createState() => _TimeChartGyroPage();
}

class _TimeChartGyroPage extends State<TimeChartGyroPage> {
  final limitCount = 20;
  final gyroXPoints = <FlSpot>[];
  final gyroYPoints = <FlSpot>[];
  final gyroZPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.5;

  late Timer timer;
  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (gyroXPoints.length > limitCount) {
        gyroXPoints.removeAt(0);
        gyroYPoints.removeAt(0);
        gyroZPoints.removeAt(0);
      }
      setState(() {
        readData();
        gyroXPoints.add(FlSpot(xValue, _dataGyroX));
        gyroYPoints.add(FlSpot(xValue, _dataGyroY));
        gyroZPoints.add(FlSpot(xValue, _dataGyroZ));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: double.infinity,
                child: Stack(children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Gyroscope Time Chart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                '___ X Axis',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '___ Y Axis',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '___ Z Axis',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // The red line
                                LineChartBarData(
                                  spots: gyroXPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[0],
                                ),
                                // The green line
                                LineChartBarData(
                                  spots: gyroYPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[1],
                                ),
                                // The blue line
                                LineChartBarData(
                                  spots: gyroZPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[2],
                                )
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text(
                                      'Angular Velocity [degrees/s]',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 0,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                    reservedSize: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                        const Text(
                          'Time [s]',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ])
                ]))));
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

class FreqChartGyroPage extends StatefulWidget {
  const FreqChartGyroPage({Key? key}) : super(key: key);

  @override
  _FreqChartGyroPage createState() => _FreqChartGyroPage();
}

class _FreqChartGyroPage extends State<FreqChartGyroPage> {
  final limitCount = 50;
  var spotsSGGyroX = <FlSpot>[];
  var spotsSGGyroY = <FlSpot>[];
  var spotsSGGyroZ = <FlSpot>[];

  var gyroXArray = Array([]);
  var gyroYArray = Array([]);
  var gyroZArray = Array([]);

  double xValue = 0;
  double step = 0.5;

  late Timer timer;
  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (gyroXArray.length > limitCount) {
        gyroXArray.removeAt(0);
        gyroYArray.removeAt(0);
        gyroZArray.removeAt(0);
      }

      setState(() {
        _TimeChartGyroPage().readData();
        gyroXArray.add(_dataGyroX);
        gyroYArray.add(_dataGyroY);
        gyroZArray.add(_dataGyroZ);
      });
      xValue += step;

//      // generate the signals for test
//      // 1Hz sine wave
      //  var N = 10.0
      // var n = limitCount.toDouble();
      // var n = 100.0;
      // var fs = 10.0; //sampling freq
      // var nDomain = linspace(0, n, num: (n * fs).toInt(), endpoint: false);
      // var f1 = 0.1; // 1Hz
      // var sg1 = arraySin(arrayMultiplyToScalar(nDomain, 2 * pi * f1));
      // print(sg1);
      // print(accelXArray);
      // var fEstAccelX = freqFromFft(sg1, fs);
      // var swFr = rfft(sg1);
      // print(swFr);

      // var swFScale = fftFreq(sg1.length, d: 1 / fs);
      // print(swFScale);
      // print(spots);
      // var fEstAccelX = freqFromFft(sg1, fs);
      // var fEstAccelY = freqFromFft(sg1, fs);
      // var fEstAccelZ = freqFromFft(sg1, fs);
      // var fEstAccelZ = freqFromFft(accelXArray, fs);
      var windowedGyroX = gyroXArray * blackmanharris(gyroXArray.length);
      var fGyroX = rfft(windowedGyroX);
      var fAbsGyroX = arrayComplexAbs(fGyroX);

      var windowedGyroY = gyroYArray * blackmanharris(gyroYArray.length);
      var fGyroY = rfft(windowedGyroY);
      var fAbsGyroY = arrayComplexAbs(fGyroY);

      var windowedGyroZ = gyroZArray * blackmanharris(gyroZArray.length);
      var fGyroZ = rfft(windowedGyroZ);
      var fAbsGyroZ = arrayComplexAbs(fGyroZ);

      // print('fAbs : $fAbs');
      // print(
      //     'The original and estimated frequency need be very close each other');
      // print('Estimated frequency Accel X: $fEstAccelX');
      // print('Estimated frequency Accel X: $fEstAccelY');
      // print('Estimated frequency Accel X: $fEstAccelZ');

      // print(rifft(swFr)); // inverse FFT of a real FFT

      // print(dbfft(sg1, fs)); // Return the frequency and fft in DB scale

      spotsSGGyroX = fAbsGyroX.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      spotsSGGyroY = fAbsGyroY.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      spotsSGGyroZ = fAbsGyroZ.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      // spotsSGY = fEstAccelY.asMap().entries.map((e) {
      //   return FlSpot(e.key.toDouble(), e.value);
      // }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: double.infinity,
                child: Stack(children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Gyroscope Spectogram',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                '___ X Axis',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '___ Y Axis',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '___ Z Axis',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // The red line
                                LineChartBarData(
                                  spots: spotsSGGyroX,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[0],
                                ),
                                // The green line
                                LineChartBarData(
                                  spots: spotsSGGyroY,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[1],
                                ),
                                // The blue line
                                LineChartBarData(
                                  spots: spotsSGGyroZ,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[2],
                                )
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text('Gain [dB]',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 0,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                    reservedSize: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                        const Text(
                          'Frequency [Hz]',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ])
                ]))));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  double freqFromFft(Array sig, double fs) {
    // Estimate frequency from peak of FFT

    // Compute Fourier transform of windowed signal
    // Avoid spectral leakage: https://en.wikipedia.org/wiki/Spectral_leakage
    var windowed = sig * blackmanharris(sig.length);
    var f = rfft(windowed);

    var fAbs = arrayComplexAbs(f);

    // Find the peak and interpolate to get a more accurate peak
    var i = arrayArgMax(fAbs); // Just use this for less-accurate, naive version

    // Parabolic approximation is necessary to get the exactly frequency of a discrete signal
    // since the frequency can be in some point between the samples.
    var trueI = parabolic(arrayLog(fAbs), i)[0];

    // Convert to equivalent frequency
    return fs * trueI / windowed.length;
  }
}
