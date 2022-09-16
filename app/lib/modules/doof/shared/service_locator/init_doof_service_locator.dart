import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';

extension DoofServiceLocator on GetIt {
  Future<void> initDoofServiceLocator() async {
    registerSingleton(FirebaseFirestore.instance);
    registerFactory(ProductsRepository.new);
    registerFactory(AdditionsRepository.new);
  }
}
