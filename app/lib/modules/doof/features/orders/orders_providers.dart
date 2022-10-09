import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:tuple/tuple.dart';

abstract class OrdersProviders {
  static final sent = StreamProvider((ref) {
    return get<OrdersRepository>().watchSent();
  });

  static final single = FutureProvider.family((ref, String orderId) async {
    final orders = await ref.watch(_all.future);
    return orders.firstWhere((order) => order.id == orderId);
  });

  static final cart = StreamProvider((ref) {
    return get<OrdersRepository>().watchCart();
  });

  static final _all = StreamProvider((ref) {
    return get<OrdersRepository>().watchAll();
  });
}

abstract class OrderProductsProviders {
  static final all = StreamProvider.family((ref, String orderId) {
    return get<OrderProductsRepository>().watch(orderId);
  });

  static final single = FutureProvider.family((ref, Tuple2<String, String> ids) async {
    final products = await ref.watch(all(ids.item1).future);
    return products.firstWhereOrNull((order) => order.id == ids.item2);
  });
}
