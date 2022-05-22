import 'package:flutter/cupertino.dart';

abstract class Hub {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState get navigator => navigatorKey.currentState!;

  static void pop<T>([T? result]) => navigator.pop<T>(result);

  static Future<T?> push<T>(Widget screen) {
    return navigator.push<T>(CupertinoPageRoute(builder: (context) {
      return screen;
    }));
  }
}
