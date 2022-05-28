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

  FirebaseFirestore get readFirestore => ref.read(Providers.firestore);
  FirebaseFirestore get watchFirestore => ref.watch(Providers.firestore);

  CollectionReference<T> get readCollection {
    return readFirestore.collection(collectionName).withJsonConverter(fromFirestore);
  }

  CollectionReference<T> get watchCollection {
    return watchFirestore.collection(collectionName).withJsonConverter(fromFirestore);
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

  Future<void> create(T dto) async {
    await box.readCollection.add(dto);
  }

  Future<void> update(T dto) async {
    await box.readCollection.doc(dto.id).set(dto);
  }

  Future<void> delete(String dtoId) async {
    await box.readCollection.doc(dtoId).delete();
  }
}

mixin Dto {
  String get id;

  bool get hasId => id.isNotEmpty;
}
