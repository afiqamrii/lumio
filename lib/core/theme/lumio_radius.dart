import 'package:flutter/material.dart';

abstract final class LumioRadius {
  static const small = 12.0;
  static const medium = 18.0;
  static const large = 24.0;
  static const pill = 999.0;

  static const card = BorderRadius.all(Radius.circular(large));
  static const button = BorderRadius.all(Radius.circular(medium));
}
