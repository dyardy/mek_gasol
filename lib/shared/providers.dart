import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Providers {
  static final firestore = Provider((ref) {
    return FirebaseFirestore.instance;
  });
}

extension FirestoreExtensions<T> on CollectionReference<T> {
  CollectionReference<R> withJsonConverter<R extends Object>(
    R Function(Map<String, dynamic> json) fromFirestore,
  ) {
    return withConverter<R>(fromFirestore: (snapshot, _) {
      return fromFirestore({'id': snapshot.id, ...snapshot.data()!});
    }, toFirestore: (value, _) {
      return {...((value as dynamic).toJson() as Map<String, dynamic>)}..remove('id');
    });
  }
}
