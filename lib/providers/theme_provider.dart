import 'package:flutter/material.dart';
import 'package:produtos_itaoleo/app_colors.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.accent,
        cardColor: AppColors.pad,
        focusColor: AppColors.white,
        canvasColor: AppColors.white,
        scaffoldBackgroundColor: AppColors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.black,
          titleTextStyle: TextStyle(
            color: AppColors.accent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 221, 138, 13),
        cardColor: AppColors.whitePad,
        focusColor: AppColors.blackText,
        canvasColor: AppColors.black,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.accent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
