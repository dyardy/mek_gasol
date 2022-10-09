import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/categories/repositories/categories_repository.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/repositories/ingredients_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';

extension DoofServiceLocator on GetIt {
  Future<void> initDoofServiceLocator() async {
    registerSingleton(FirebaseAuth.instance);
    registerSingleton(FirebaseFirestore.instance);

    registerFactory(UsersRepository.new);

    registerFactory(CategoriesRepository.new);

    registerFactory(ProductsRepository.new);

    registerFactory(AdditionsRepository.new);

    registerFactory(IngredientsRepository.new);

    registerFactory(OrdersRepository.new);
    registerFactory(OrderProductsRepository.new);
  }
}
