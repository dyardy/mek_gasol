import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/repositories/ingredients_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:rxdart/rxdart.dart';

extension DoofServiceLocator on GetIt {
  Future<void> initDoofServiceLocator() async {
    registerSingleton(FirebaseFirestore.instance);

    registerFactory(UsersRepository.new);

    registerFactory(ProductsRepository.new);

    registerFactory(AdditionsRepository.new);

    registerFactory(IngredientsRepository.new);

    registerFactory(OrdersRepository.new);
    registerFactory(OrderProductsRepository.new);

    registerLazySingleton<QueryBloc<UserDto?>>(() {
      return QueryBloc(() {
        return FirebaseAuth.instance.userChanges().switchMap((user) async* {
          if (user == null) {
            yield null;
            return;
          }
          yield* get<UsersRepository>().watch(user.uid);
        });
      });
    });
    registerFactory<StateStreamable<QueryState<UserDto?>>>(() => get<QueryBloc<UserDto?>>());
    registerFactory<UserDto>(() => get<QueryBloc<UserDto?>>().state.data!);
    registerFactory<PublicUserDto>(() => get<QueryBloc<UserDto?>>().state.data!);
  }
}
