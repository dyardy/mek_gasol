import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class UsersRepo {
  static final instance = Provider((ref) {
    return UsersRepo(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  UsersRepo(this._ref);

  CollectionReference<UserDto> get _collection {
    return _firestore.collection('users').withJsonConverter(UserDto.fromJson);
  }

  Stream<List<UserDto>> watchAll() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
