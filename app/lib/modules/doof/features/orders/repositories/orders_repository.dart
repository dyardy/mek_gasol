import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/providers.dart';

class OrdersRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = 'orders';

  CollectionReference<OrderDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(OrderDto.fromJson);

  Future<void> create() async {
    final draftOrder = OrderDto(
      id: '',
      createdAt: DateTime.now(),
      status: OrderStatus.draft,
    );
    await _ref().doc().set(draftOrder);
  }

  Future<void> update(OrderDto orderDto) async {
    await _ref().doc(orderDto.id).update(orderDto.toJson());
  }

  Future<void> delete(OrderDto order) async {
    if (order.status != OrderStatus.draft) throw 'Cant delete order';
    await _ref().doc(order.id).delete();
  }

  Future<List<OrderDto>> fetch() async {
    final snapshot = await _ref().get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<OrderDto>> watch() {
    return _ref().snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }
}
