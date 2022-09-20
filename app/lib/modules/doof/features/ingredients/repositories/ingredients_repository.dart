import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:pure_extensions/pure_extensions.dart';

class IngredientsRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = 'ingredients';

  CollectionReference<IngredientDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(IngredientDto.fromJson);

  Future<void> save(IngredientDto product) async {
    await _ref().doc(product.id.nullIfEmpty()).set(product);
  }

  Future<void> delete(IngredientDto product) async {
    await _ref().doc(product.id).delete();
  }

  Future<List<IngredientDto>> fetch() async {
    final snapshot = await _ref().orderBy('title').get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<IngredientDto>> watch(ProductDto product) {
    return _ref()
        .where('productIds', arrayContains: product.id)
        .orderBy('title')
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
