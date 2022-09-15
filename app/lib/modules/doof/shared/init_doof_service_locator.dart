import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';

extension DoofServiceLocator on GetIt {
  void initDoofServiceLocator() {
    registerSingleton(FirebaseFirestore.instance);
    registerSingleton(ProductsRepository());
  }
}
