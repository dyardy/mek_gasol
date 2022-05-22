import 'package:flutter/material.dart';
import 'package:pure_extensions/pure_extensions.dart';

extension ToDateTimeOnTimeOfDay on TimeOfDay {
  DateTime toDateTime(DateTime original) {
    return original.copyWith(hour: hour, minute: minute);
  }
}
