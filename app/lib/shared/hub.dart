import 'package:flutter/cupertino.dart';

extension HubOnBuildContext on BuildContext {
  Hub get hub => Hub._(Navigator.of(this));
}

class Hub {
  final NavigatorState _navigator;

  Hub._(this._navigator);

  void pop<T>([T? result]) => _navigator.pop<T>(result);

  Future<T?> push<T>(Widget screen) {
    return _navigator.push<T>(CupertinoPageRoute(builder: (context) {
      return screen;
    }));
  }
}
