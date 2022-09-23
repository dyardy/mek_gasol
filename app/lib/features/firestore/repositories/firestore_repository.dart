import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/packages/firestore.dart';

typedef DtoFromFirestore<T> = T Function(Map<String, dynamic> json);

class FirestoreBox<T extends Dto> {
  final String collectionName;
  final DtoFromFirestore<T> fromFirestore;

  const FirestoreBox._({
    required this.collectionName,
    required this.fromFirestore,
  });

  FirebaseFirestore get firestore => get();

  CollectionReference<T> get collection {
    return firestore.collection(collectionName).withJsonConverter(fromFirestore);
  }
}

abstract class FirestoreRepository<T extends Dto> {
  @protected
  final FirestoreBox<T> box;

  FirestoreRepository({
    required String collectionName,
    required DtoFromFirestore<T> fromFirestore,
  }) : box = FirestoreBox._(
          collectionName: collectionName,
          fromFirestore: fromFirestore,
        );

  Future<void> create(T dto) async {
    await box.collection.add(dto);
  }

  Future<void> update(T dto) async {
    await box.collection.doc(dto.id).set(dto);
  }

  Future<void> delete(String dtoId) async {
    await box.collection.doc(dtoId).delete();
  }
}

mixin Dto {
  String get id;

  bool get hasId => id.isNotEmpty;
}
