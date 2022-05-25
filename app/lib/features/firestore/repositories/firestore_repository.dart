import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/shared/providers.dart';

class FirestoreContext<T extends Dto> {
  final Ref ref;
  final String collectionName;
  final T Function(Map<String, dynamic> json) fromFirestore;

  const FirestoreContext({
    required this.ref,
    required this.collectionName,
    required this.fromFirestore,
  });

  FirebaseFirestore get firestore => ref.read(Providers.firestore);

  CollectionReference<T> get collection {
    return firestore.collection('clients').withJsonConverter(fromFirestore);
  }
}

class FirestoreRepository<T extends Dto> {
  @protected
  final FirestoreContext<T> context;

  FirestoreRepository(this.context);

  CollectionReference<T> get _collection => context.collection;

  Future<void> create(T dto) async {
    await _collection.add(dto);
  }

  Future<void> update(T dto) async {
    await _collection.doc(dto.id).set(dto);
  }

  Future<void> delete(String dtoId) async {
    await _collection.doc(dtoId).delete();
  }
}

abstract class Dto {
  String get id;

  const Dto();
}
