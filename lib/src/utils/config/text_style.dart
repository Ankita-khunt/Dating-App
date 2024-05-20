import 'package:dating_app/imports.dart';

class TextStyleConfig {
  static double bodyText10 = 10;

  static double bodyText12 = 12;
  static double bodyText14 = 14;
  static double bodyText15 = 15;

  static double bodyText16 = 16;
  static double bodyText18 = 18;
  static double bodyText20 = 20;

  static double bodyText22 = 22;
  static double bodyText24 = 24;

  static double bodyText28 = 28;
  static double bodyText30 = 30;

  static double bodyText32 = 32;

  /// Regular Text style
  static TextStyle regularTextStyle(
      {required double fontSize,
      Color? color = Colors.black,
      double? styleLineHeight = 1.5,
      TextDecoration? decoration = TextDecoration.none,
      FontWeight? fontWeight = FontWeight.normal}) {
    return TextStyle(
        fontFamily: FontFamilyConstants.fontfamily,
        color: color,
        decoration: decoration,
        height: styleLineHeight,
        fontWeight: fontWeight,
        fontSize: fontSize);
  }

  /// Bold Text style
  static TextStyle boldTextStyle(
      {required double fontSize,
      Color? color = Colors.black,
      double? styleLineHeight = 1.5,
      TextDecoration? decoration = TextDecoration.none,
      FontWeight? fontWeight = FontWeight.bold}) {
    return TextStyle(
        fontFamily: FontFamilyConstants.fontfamily,
        color: color,
        height: styleLineHeight,
        decoration: decoration,
        fontWeight: fontWeight,
        fontSize: fontSize);
  }
}
