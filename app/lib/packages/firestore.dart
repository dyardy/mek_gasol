import 'package:cloud_firestore/cloud_firestore.dart';

extension CollectionReferenceExtensions<T> on CollectionReference<T> {
  Query<T> asQuery() => this;

  CollectionReference<R> withJsonConverter<R extends Object>(
    R Function(Map<String, dynamic> json) fromFirestore,
  ) {
    return asQuery().withJsonConverter(fromFirestore) as CollectionReference<R>;
  }
}

extension QueryExtensions<T> on Query<T> {
  Query<R> withJsonConverter<R extends Object>(
    R Function(Map<String, dynamic> json) fromFirestore,
  ) {
    return withConverter<R>(fromFirestore: (snapshot, _) {
      return fromFirestore({'id': snapshot.id, ...snapshot.data()!});
    }, toFirestore: (value, _) {
      return {...((value as dynamic).toJson() as Map<String, dynamic>)}..remove('id');
    });
  }
}
