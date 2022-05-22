import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';

abstract class Providers {
  static final auth = Provider((ref) {
    return FirebaseAuth.instance;
  });

  static final firestore = Provider((ref) {
    return FirebaseFirestore.instance;
  });

  static final user = FutureProvider<UserDto>((ref) async {
    final auth = ref.watch(Providers.auth);
    var user = auth.currentUser;
    if (user == null) {
      final credenties = await auth.signInWithEmailAndPassword(
        email: 'brexmaster@gmail.com',
        password: 'Password123\$',
      );
      user = credenties.user!;
    }

    return UserDto(
      id: user.uid,
      email: user.email!,
    );
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

extension AsQueryCollection<T> on CollectionReference<T> {
  Query<T> asQuery() => this;
}
