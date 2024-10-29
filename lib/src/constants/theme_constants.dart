import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.yellow,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.yellow,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.yellow,
    foregroundColor: Colors.black,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.yellow,
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
  ),
);
