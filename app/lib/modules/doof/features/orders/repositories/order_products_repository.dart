import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:pure_extensions/pure_extensions.dart';

class OrderProductsRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = 'products';

  CollectionReference<ProductOrderDto> _ref(String orderId) => _firestore
      .collection(OrdersRepository.collection)
      .doc(orderId)
      .collection(collection)
      .withJsonConverter(ProductOrderDto.fromJson);

  Future<void> save(OrderDto order, ProductOrderDto productOrder) async {
    await _ref(order.id).doc(productOrder.id.nullIfEmpty()).set(productOrder);
  }

  Future<void> delete(OrderDto order, ProductOrderDto productOrder) async {
    await _ref(order.id).doc(productOrder.id).delete();
  }

  Future<List<ProductOrderDto>> fetch(OrderDto order) async {
    final snapshot = await _ref(order.id).get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<ProductOrderDto>> watch(OrderDto order) {
    return _ref(order.id).snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }
}
