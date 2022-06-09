import 'package:flutter/material.dart';

ButtonStyle whiteButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  padding: EdgeInsets.zero,
  primary: Colors.white,
  onPrimary: Colors.blue,
  alignment: Alignment.center,
  fixedSize: const Size(double.infinity, 50.0),
);
