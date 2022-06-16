import 'package:flutter/material.dart';

ButtonStyle whiteButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  padding: EdgeInsets.zero,
  primary: Colors.white,
  onPrimary: Colors.blue,
  alignment: Alignment.center,
  fixedSize: const Size(double.infinity, 50.0),
);

ButtonStyle blueButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  padding: EdgeInsets.zero,
  primary: Colors.blue,
  onPrimary: Colors.white,
  alignment: Alignment.center,
  fixedSize: const Size(double.infinity, 50.0),
);

ButtonStyle transparentButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  padding: EdgeInsets.zero,
  primary: Colors.transparent,
  shadowColor: Colors.transparent,
  onPrimary: Colors.white,
  alignment: Alignment.center,
  fixedSize: const Size(double.infinity, 50.0),
);
