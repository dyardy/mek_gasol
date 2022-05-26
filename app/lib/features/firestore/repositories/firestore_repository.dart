import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/shared/providers.dart';

typedef DtoFromFirestore<T> = T Function(Map<String, dynamic> json);

class FirestoreBox<T extends Dto> {
  final Ref ref;
  final String collectionName;
  final DtoFromFirestore<T> fromFirestore;

  const FirestoreBox._({
    required this.ref,
    required this.collectionName,
    required this.fromFirestore,
  });

  FirebaseFirestore get firestore => ref.watch(Providers.firestore);

  CollectionReference<T> get collection {
    return firestore.collection(collectionName).withJsonConverter(fromFirestore);
  }
}

abstract class FirestoreRepository<T extends Dto> {
  @protected
  final FirestoreBox<T> box;

  FirestoreRepository({
    required Ref ref,
    required String collectionName,
    required DtoFromFirestore<T> fromFirestore,
  }) : box = FirestoreBox._(
          ref: ref,
          collectionName: collectionName,
          fromFirestore: fromFirestore,
        );

  CollectionReference<T> get _collection => box.collection;

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
