import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

abstract class OrdersProviders {
  static final all = StreamProvider((ref) {
    return get<OrdersRepository>().watch();
  });

  static final cart = StreamProvider((ref) {
    return get<OrdersRepository>().watchCart();
  });
}

abstract class OrderProductsProviders {
  static final all = StreamProvider.family((ref, String orderId) {
    return get<OrderProductsRepository>().watch(orderId);
  });
}
