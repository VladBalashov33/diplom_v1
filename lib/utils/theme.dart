import 'package:flutter/material.dart';

const primaryMaterialColor = MaterialColor(
  4284513675,
  <int, Color>{
    50: Color.fromRGBO(
      96,
      125,
      139,
      .1,
    ),
    100: Color.fromRGBO(
      96,
      125,
      139,
      .2,
    ),
    200: Color.fromRGBO(
      96,
      125,
      139,
      .3,
    ),
    300: Color.fromRGBO(
      96,
      125,
      139,
      .4,
    ),
    400: Color.fromRGBO(
      96,
      125,
      139,
      .5,
    ),
    500: Color.fromRGBO(
      96,
      125,
      139,
      .6,
    ),
    600: Color.fromRGBO(
      96,
      125,
      139,
      .7,
    ),
    700: Color.fromRGBO(
      96,
      125,
      139,
      .8,
    ),
    800: Color.fromRGBO(
      96,
      125,
      139,
      .9,
    ),
    900: Color.fromRGBO(
      96,
      125,
      139,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  fontFamily: 'customFont',
  primaryColor: const Color(0xff607d8b),
  buttonColor: const Color(0xff607d8b),
  accentColor: const Color(0xff607d8b),
  primarySwatch: primaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        const Color(0xff607d8b),
      ),
    ),
  ),
);
