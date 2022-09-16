import 'dart:developer';

import 'package:logging/logging.dart';

final lg = Logger('Doof');

extension LoggerExtension on Logger {
  void initLogging() {
    Logger.root
      ..level = Level.ALL
      ..onRecord.listen(_onLogRecord);
  }
}

void _onLogRecord(LogRecord record) {
  log(record.message, name: record.level.name);
}
