
import 'package:flutter/material.dart';
const lightThemeColor=Colors.black;
const darkThemeColor=Colors.white;
const defaultPadding = 12.0;
const kCompleted='Completed';
const kProcessing='Processing';
const kCancelled='Cancelled';
const Color whiteColor= Colors.white;
const Color darkColor=Color(0xff33333f);

const Color searchTfDarkColor=Color(0xff3e3d4b);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: darkColor,
    primaryColor: darkColor,
    backgroundColor: darkColor,
    // textTheme: GoogleFonts.poppinsTextTheme().apply(
    //   displayColor:Colors.black,
    //   bodyColor: Colors.black,
    // ),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: darkThemeColor,
      selectionColor: darkThemeColor,
      selectionHandleColor: darkThemeColor,
    ),
);

ThemeData lightTheme = ThemeData(
  // textTheme: GoogleFonts.poppinsTextTheme().apply(
  //   displayColor:Colors.white,
  //   bodyColor: Colors.white,
  //
  //
  // ),
    scaffoldBackgroundColor: whiteColor,
    primaryColor: whiteColor,
    iconTheme: const IconThemeData(
      color: Colors.black
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: lightThemeColor,
      primary: lightThemeColor, //<-- SEE HERE
    ),
    hintColor: lightThemeColor,


    brightness: Brightness.light,
);