import 'package:flutter/material.dart';

extension HubOnBuildContext on BuildContext {
  Hub get hub => Hub._(Navigator.of(this));
}

class Hub {
  final NavigatorState _navigator;

  Hub._(this._navigator);

  void pop<T>([T? result]) => _navigator.pop<T>(result);

  Future<T?> push<T>(Widget screen) {
    return _navigator.push<T>(MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }

  Future<T?> pushReplacement<T>(Widget screen) {
    return _navigator.pushReplacement(MaterialPageRoute(builder: (context) {
      return screen;
    }));
  }
}
