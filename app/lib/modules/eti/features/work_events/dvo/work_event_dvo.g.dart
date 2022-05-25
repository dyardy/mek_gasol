// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_event_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$WorkEventDvo {
  WorkEventDvo get _self => this as WorkEventDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.creatorUser;
    yield _self.client;
    yield _self.project;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WorkEventDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WorkEventDvo')
        ..add('id', _self.id)
        ..add('creatorUser', _self.creatorUser)
        ..add('client', _self.client)
        ..add('project', _self.project)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note))
      .toString();
}
