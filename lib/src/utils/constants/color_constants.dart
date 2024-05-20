import 'dart:ui';

class ColorConstants {
  Color primaryGradient = HexColor("#F56C6F");
  Color secondaryGradient = HexColor("#F17F4F");
  Color green = HexColor("#3DA933");
  Color grey1 = HexColor("#5E5E5E");
  Color black = HexColor("#202226");
  Color lightgrey = HexColor("#C8C8C8");
  Color grey = HexColor("#767575");
  Color white = HexColor("#FFFFFF");
  Color greyWhite = HexColor("#F7F9FA");

  Color errorRed = HexColor("#EF1D1D");
  Color primaryLight = HexColor("#FEE9E9");
  Color lightBGgrey = HexColor("#EDEDED");
  Color light1 = HexColor("#F5F5F5");
  Color steppercolor = HexColor("#D9D9D9");

  Color dropshadow = HexColor("#000000");
  Color blurtext = HexColor("#5E5E5E");
  Color userGuideBG = HexColor("#B9B9B9");
  Color grey2 = HexColor("#A2A5B1");
}

/// Color convertor
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
