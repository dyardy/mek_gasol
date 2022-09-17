import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/controllers/order_products_controller.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';

extension DoofServiceLocator on GetIt {
  Future<void> initDoofServiceLocator() async {
    registerSingleton(FirebaseFirestore.instance);

    registerFactory(UsersRepository.new);

    registerFactory(ProductsRepository.new);

    registerFactory(AdditionsRepository.new);

    registerFactory(OrdersRepository.new);
    registerFactory(OrderProductsRepository.new);
    registerFactory(OrderProductsController.new);
  }
}
