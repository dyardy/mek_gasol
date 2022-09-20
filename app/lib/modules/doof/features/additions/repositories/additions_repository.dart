import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:pure_extensions/pure_extensions.dart';

class AdditionsRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = 'additions';

  CollectionReference<AdditionDto> _ref() =>
      _firestore.collection('additions').withJsonConverter(AdditionDto.fromJson);

  Future<void> save(AdditionDto product) async {
    await _ref().doc(product.id.nullIfEmpty()).set(product);
  }

  Future<void> delete(AdditionDto product) async {
    await _ref().doc(product.id).delete();
  }

  Future<List<AdditionDto>> fetch() async {
    final snapshot = await _ref().get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<AdditionDto>> watch(ProductDto productId) {
    return _ref()
        .where('productIds', arrayContains: productId.id)
        .orderBy('title')
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
