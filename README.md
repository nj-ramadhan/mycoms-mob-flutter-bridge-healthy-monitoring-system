# SHMS mobile app

flutter - firebase realtime database

A new Flutter project to monitor Accelerometer and Gyroscope Data in Android Devices.

Data sent from ESP32 to Firebase RTDB (Realtime Database)
Arduino IDE used as programming tool for ESP32 device, arduino code is uploaded in ESP32_MPU6500 folder 


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Feature

This app shows accelerometer and gyroscope data line chart in time domain 
and shows spectogram chart in frequency domain using fft algorithm to generate the data

This project using fl_chart library to show graph and scidart to do fourier transform functions 


