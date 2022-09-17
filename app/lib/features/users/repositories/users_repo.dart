import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';

class UsersRepository {
  FirebaseFirestore get _firestore => get();

  CollectionReference<UserDto> _ref() {
    return _firestore.collection('users').withJsonConverter(UserDto.fromJson);
  }

  Stream<List<UserDto>> watchAll() {
    return _ref().snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
