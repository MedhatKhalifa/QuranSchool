import 'package:flutter/material.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  static double screenWidth=0;
  static double screenHeight=0;
  static double defaultSize=0;
  late Orientation orientation;
  static double blockSizeHorizontal=0;
  static double blockSizeVertical=0;

  static double _safeAreaHorizontal=0;
  static double _safeAreaVertical=0;
  static double safeBlockHorizontal=0;
  static double safeBlockVertical=0;
  late DeviceType devicetype;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical =
        (screenHeight - _safeAreaVertical - kToolbarHeight) / 100;
    devicetype = getDeviceType(_mediaQueryData);
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

double w(double inputWidth) {
  return SizeConfig.safeBlockHorizontal * inputWidth;
}

double h(double inputHeight) {
  return SizeConfig.safeBlockVertical * inputHeight;
}

 double sp(double inputsp) {
  return SizeConfig.safeBlockHorizontal * inputsp/3;
}



enum DeviceType { Mobile, Tablet, Desktop }

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double width = 0;
  if (orientation == Orientation.landscape) {
    width = mediaQueryData.size.height;
  } else {
    width = mediaQueryData.size.width;
  }
  if (width >= 950) {
    return DeviceType.Desktop;
  }
  if (width >= 600) {
    return DeviceType.Tablet;
  }
  return DeviceType.Mobile;
}
