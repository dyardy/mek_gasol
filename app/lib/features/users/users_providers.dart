import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/logger.dart';
import 'package:rxdart/rxdart.dart';

enum SingStatus { none, partial, full }

abstract class UsersProviders {
  static final all = StreamProvider((ref) {
    return get<UsersRepository>().watchAll();
  });

  static final current = StateProvider<UserDto>((ref) {
    return const UserDto(
      id: '',
      email: '',
      displayName: '',
    );
  });

  static final currentStatus = FutureProvider((ref) async {
    final authUser = await ref.watch(_currentAuth.future);
    if (authUser == null) return SingStatus.none;

    final user = await ref.watch(_single(authUser.uid).future);
    if (user == null) return SingStatus.partial;

    ref.read(current.notifier).state = user;

    return SingStatus.full;
  });

  static final _currentAuth = StreamProvider((ref) {
    return FirebaseAuth.instance.userChanges();
  });

  static final _single = StreamProvider.family((ref, String userId) {
    return get<UsersRepository>().watch(userId).doOnData((user) => lg.info('DbUser: ${user?.id}'));
  });
}
