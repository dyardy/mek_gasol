import 'package:firebase_auth/firebase_auth.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/features/additions/addition_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dvo/product_order_dvo.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:rxdart/rxdart.dart';

class OrderProductsController {
  OrderProductsRepository get _orderProductsRepository => get();
  UsersRepository get _usersRepo => get();

  Stream<List<ProductOrderDvo>> watch(OrderDto order) {
    return Rx.combineLatest2(_orderProductsRepository.watch(order), _usersRepo.watchAll(),
        (products, users) {
      return products.map((product) {
        return ProductOrderDvo(
          id: product.id,
          user: users.firstWhere((e) => e.id == product.userId),
          productId: product.productId,
          title: product.title,
          description: product.description,
          price: product.price,
          quantity: product.quantity,
          additions: product.additions,
        );
      }).toList();
    });
  }

  Future<void> delete(OrderDto order, ProductOrderDvo product) async {
    await _orderProductsRepository.delete(order, product);
  }

  Future<void> create(OrderDto order, ProductDto product, List<AdditionDto> additions) async {
    final orderProduct = ProductOrderDto(
      id: '',
      productId: product.id,
      userId: FirebaseAuth.instance.currentUser!.uid,
      quantity: 1,
      price: product.price,
      title: product.title,
      description: product.description,
      additions: additions.map((e) {
        return AdditionOrderDto(
          additionId: e.id,
          title: e.title,
          description: e.description,
          price: e.price,
        );
      }).toList(),
    );
    await _orderProductsRepository.create(order, orderProduct);
  }
}
