import 'package:flutter/material.dart';

class Colours {
  //Private constructor cause is not needed to instantiate this class
  Colours._();

  static const white = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE0E0E0);
  static const red = Colors.red;
 static const shadowHideMenu = Color.fromARGB(255, 158, 158, 158);
  static const background = Color(0xFFedf7ff);
  static const backgroundDark = Color(0xFF002234);

  static const colorsButtonMenu =Color(0xffEA7C69);


  static const int _error = 0xFFCD2932;
  static const Color error100 = Color(0xFFFFF1F0);
  static const Color error200 = Color(0xFFFFD4D6);
  static const Color error400 = Color(0xFFF67D83);
  static const Color error800 = Color(0xFFCD2932);
  static const Color error1000 = Color(0xFFCD2932);

  static const MaterialColor errorPalette = MaterialColor(
    _error,
    <int, Color>{
      100: error100,
      200: error200,
      400: error400,
      800: error800,
      1000: error1000,
    },
  );

  static const int _primary = 0xFF1F1D2B;
  static const Color primary100 = Color(0xFF393C49);
  static const MaterialColor primaryPalette = MaterialColor(
    _primary,
    <int, Color>{
      100: primary100,
    },
  );


  static const int _brand = 0xFF003070;
  static const Color brand100 = Color(0xFFD2ECFC);
  static const Color brand200 = Color(0xFFA1DEFC);
  static const Color brand400 = Color(0xFF0094D7);
  static const Color brand800 = Color(0xFF077AC0);
  static const Color brand1000 = Color(0xFF003070);
  static const Color brandColor = Color(0xFF0099D8);

  static const MaterialColor brandPalette = MaterialColor(
    _brand,
    <int, Color>{
      100: brand100,
      200: brand200,
      400: brand400,
      800: brand800,
      1000: brand1000,
    },
  );



  static const Color contextuelDisabled1 = Color(0xFF939598);
  static const Color contextuelDisabled2 = Color(0xFFBDBDBD);
  static const Color contextuelBackground = Color(0xFFFAFAFA);
  static const Color contextuelWhite = Color(0xFFFFFFFF);
  static const Color contextuelBlack = Color(0xFF000000);
  static const Color contextuelBlueBackground = Color(0xFFEDF7FF);
  static const Color contextuelGradientBG = Color(0xFFEDF7FF);
  static const Color contextuelTextDisabled = Color(0xFF747678);

  static const Color ttextPrimary = Color(0xFF333333);
  static const Color ttextSecondary = Color(0xFF4F4F4F);
  static const Color textLink1 = Color(0xFF003070);
  static const Color textLink2 = Color(0xFF0094D7);
  static const Color linkBoxBG = Color(0xFFEAF8FF);

  static BoxShadow bleueBox = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 1),
    blurRadius: 3,
  );
}
