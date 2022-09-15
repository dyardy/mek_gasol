import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';

class ProductsRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  CollectionReference<ProductDto> _ref() =>
      _firestore.collection('products').withJsonConverter(ProductDto.fromJson);

  Stream<List<ProductDto>> watch() {
    return _ref().snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<void> create(ProductDto product) async {
    await _ref().add(product);
  }
}
