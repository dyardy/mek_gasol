import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/packages/firestore.dart';
import 'package:mek_gasol/shared/env.dart';
import 'package:pure_extensions/pure_extensions.dart';

class ProductsRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = '${Env.prefix}products';

  CollectionReference<ProductDto> _ref() => _firestore
      // .collection(CategoriesRepository.collection)
      // .doc(categoryId)
      .collection(collection)
      .withJsonConverter(ProductDto.fromJson);

  // Query<ProductDto> _refGroup() =>
  //     _firestore.collectionGroup(collection).withJsonConverter(ProductDto.fromJson);

  Future<void> save(ProductDto product) async {
    await _ref().doc(product.id.nullIfEmpty()).set(product);
  }

  Future<void> delete(ProductDto product) async {
    await _ref().doc(product.id).delete();
  }

  Future<List<ProductDto>> fetch() async {
    final snapshot = await _ref().orderBy(ProductDto.fields.title).get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<ProductDto>> watch() {
    return _ref()
        .orderBy(ProductDto.fields.title)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
