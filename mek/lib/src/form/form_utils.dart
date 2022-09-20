import 'package:flutter/material.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';

extension FieldBlocStateBaseExtensions<TValue> on FieldBlocStateBase<TValue> {
  String? widgetError(BuildContext context) {
    return isInvalid && isTouched ? '${errors.first}' : null;
  }

  R? ifEnabled<R>(R result) {
    return isEnabled ? result : null;
  }
}

extension ListFieldBlocBaseExtensions<T> on FieldBlocRule<List<T>> {
  void changeAddingValues(T value) {
    changeValue([...state.value, value]);
  }

  void changeRemovingValues(T value) {
    changeValue([...state.value]..remove(value));
  }
}

extension ListFieldBlocStateBaseExtensions<T> on FieldBlocStateBase<List<T>> {
  ValueChanged<bool?>? widgetSelectHandler(FieldBlocRule<List<T>> fieldBloc, T value) {
    return ifEnabled((isSelected) {
      if (isSelected!) {
        fieldBloc.changeAddingValues(value);
      } else {
        fieldBloc.changeRemovingValues(value);
      }
    });
  }
}
