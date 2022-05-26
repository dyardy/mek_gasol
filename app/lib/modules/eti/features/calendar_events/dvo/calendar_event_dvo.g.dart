// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$WorkEventCalendarDvo {
  WorkEventCalendarDvo get _self => this as WorkEventCalendarDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
    yield _self.client;
    yield _self.project;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WorkEventCalendarDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WorkEventCalendarDvo')
        ..add('id', _self.id)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid)
        ..add('client', _self.client)
        ..add('project', _self.project))
      .toString();
}

mixin _$HolidayEventCalendarDvo {
  HolidayEventCalendarDvo get _self => this as HolidayEventCalendarDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$HolidayEventCalendarDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('HolidayEventCalendarDvo')
        ..add('id', _self.id)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid))
      .toString();
}

mixin _$VacationEventCalendarDvo {
  VacationEventCalendarDvo get _self => this as VacationEventCalendarDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$VacationEventCalendarDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('VacationEventCalendarDvo')
        ..add('id', _self.id)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid))
      .toString();
}
