import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/auth/sign_up_details_screen.dart';
import 'package:mek_gasol/modules/auth/sign_up_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/orders_providers.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_screen.dart';
import 'package:mek_gasol/modules/doof/features/products/products_providers.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:tuple/tuple.dart';

part 'routes.g.dart';

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Widget build(BuildContext context) => const SignInScreen();
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up')
class SignUpRoute extends GoRouteData {
  const SignUpRoute();

  @override
  Widget build(BuildContext context) => const SignUpScreen();
}

@TypedGoRoute<SignUpDetailsRoute>(path: '/sign-details')
class SignUpDetailsRoute extends GoRouteData {
  const SignUpDetailsRoute();

  @override
  Widget build(BuildContext context) => const SignUpDetailsScreen();
}

@TypedGoRoute<UserAreaRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProductRoute>(path: 'products/:productId'),
    TypedGoRoute<OrderRoute>(
      path: 'orders/:orderId',
      routes: [
        TypedGoRoute<OrderProductRoute>(path: 'products/:orderProductId'),
      ],
    ),
    TypedGoRoute<CartProductRoute>(path: 'cart/:orderProductId'),
  ],
)
class UserAreaRoute extends GoRouteData {
  const UserAreaRoute();

  @override
  Widget build(BuildContext context) => const UserArea();
}

class ProductRoute extends GoRouteData {
  final String productId;

  const ProductRoute(this.productId);

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: Provide.combineAsync2(
        OrdersProviders.cart,
        ProductsProviders.single(productId),
      ),
      builder: (context, ref, vls) {
        return ProductScreen(
          order: vls.item1,
          product: vls.item2,
        );
      },
    );
  }
}

class OrderRoute extends GoRouteData {
  final String orderId;

  const OrderRoute(this.orderId);

  @override
  Widget build(BuildContext context) => OrderScreen(orderId: orderId);
}

class OrderProductRoute extends GoRouteData {
  final String orderId;
  final String orderProductId;

  const OrderProductRoute(this.orderId, this.orderProductId);

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: Provide.combineAsync2(
        OrdersProviders.single(orderId),
        OrderProductsProviders.single(Tuple2(orderId, orderProductId)),
      ),
      builder: (context, ref, vls) {
        return ProductScreen(
          order: vls.item1,
          productOrder: vls.item2,
          product: vls.item2.product,
        );
      },
    );
  }
}

class CartProductRoute extends GoRouteData {
  final String orderProductId;

  const CartProductRoute(this.orderProductId);

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: OrdersProviders.cart,
      builder: (context, ref, cart) {
        return AsyncViewBuilder(
          provider: OrderProductsProviders.single(Tuple2(cart.id, orderProductId)),
          builder: (context, ref, orderProduct) {
            return ProductScreen(
              order: cart,
              productOrder: orderProduct,
              product: orderProduct.product,
            );
          },
        );
      },
    );
  }
}
