import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/packages/firestore.dart';
import 'package:mek_gasol/shared/env.dart';

class OrdersRepository {
  FirebaseFirestore get _firestore => get<FirebaseFirestore>();

  static const String collection = '${Env.prefix}orders';

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

  Future<void> markSent(OrderDto orderDto) async {
    await create();
    await _ref().doc(orderDto.id).set(orderDto.change((c) => c..status = OrderStatus.sent));
  }

  Future<void> delete(OrderDto order) async {
    if (order.status != OrderStatus.draft) throw 'Cant delete draft order';
    await _ref().doc(order.id).delete();
  }

  Future<List<OrderDto>> fetch() async {
    final snapshot = await _ref().orderBy(OrderDto.fields.createdAt, descending: true).get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<OrderDto>> watchSent() {
    return _ref()
        .where(OrderDto.fields.status, isEqualTo: OrderStatus.sent.name)
        .orderBy(OrderDto.fields.createdAt, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<List<OrderDto>> watchAll() {
    return _ref()
        .orderBy(OrderDto.fields.createdAt, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Stream<OrderDto> watchCart() {
    return _ref()
        .where(OrderDto.fields.status, isEqualTo: OrderStatus.draft.name)
        .orderBy(OrderDto.fields.createdAt, descending: true)
        .snapshots()
        .map((event) {
      return event.docs.first.data();
    });
  }
}
