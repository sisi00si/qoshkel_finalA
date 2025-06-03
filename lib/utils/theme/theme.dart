import 'package:QoshKel/utils/theme/custom_themes/appbar_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/chip_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/text_field_theme.dart';
import 'package:QoshKel/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class QKAppTheme {
  QKAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: QKTextTheme.lightTextTheme,
    chipTheme: QKChipTheme.lightChipTheme,
    appBarTheme: QKAppBarTheme.lightAppBarTheme,
    checkboxTheme: QKCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: QKBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: QKElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: QKOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: QKTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: QKTextTheme.darkTextTheme,
    chipTheme: QKChipTheme.darkChipTheme,
    appBarTheme: QKAppBarTheme.darkAppBarTheme,
    checkboxTheme: QKCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: QKBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: QKElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: QKOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: QKTextFormFieldTheme.darkInputDecorationTheme,
  );
}