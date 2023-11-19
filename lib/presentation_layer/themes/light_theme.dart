import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'Telegraf',
    brightness: Brightness.light,
    appBarTheme:
        const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
    colorScheme: const ColorScheme.light(
        background: Color.fromARGB(255, 248, 232, 186),
        primary: Color.fromARGB(255, 246, 239, 217),
        secondary: Colors.grey));
