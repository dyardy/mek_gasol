import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';

class UsersRepository {
  FirebaseAuth get _auth => get();
  FirebaseFirestore get _firestore => get();

  CollectionReference<UserDto> _ref() {
    return _firestore.collection('users').withJsonConverter(UserDto.fromJson);
  }

  Future<void> create({required String displayName}) async {
    final user = UserDto(
      id: '',
      email: _auth.currentUser!.email!,
      displayName: displayName,
    );
    await _ref().doc(_auth.currentUser!.uid).set(user);
  }

  Stream<UserDto?> watch(String uid) {
    return _ref().doc(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Stream<List<PublicUserDto>> watchAll() {
    return _ref().snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
