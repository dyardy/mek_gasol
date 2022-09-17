import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

abstract class Providers {
  static final auth = Provider((ref) {
    return FirebaseAuth.instance;
  });

  static final firestore = Provider((ref) {
    return FirebaseFirestore.instance;
  });

  // TODO: rename to currentUser
  static final userStatus = StreamProvider((ref) async* {
    final auth = ref.watch(Providers.auth);

    await for (final user in auth.authStateChanges()) {
      if (user == null) {
        yield null;
        continue;
      }

      yield UserDto(
        id: user.uid,
        email: user.email!,
        displayName: user.displayName ?? user.email!,
      );
    }
  });

  // TODO: rename to signedUser
  // Il tipo è richiesto perchè sennò lo segna come nullabile
  static final user = StreamProvider<UserDto>((ref) async* {
    final userStream = ref.watch(userStatus.stream);

    await for (final user in userStream) {
      if (user == null) continue;
      yield user;
    }
  });

  static final users = StreamProvider((ref) async* {
    yield* get<UsersRepository>().watchAll();
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
