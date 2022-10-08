import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/users/users_providers.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/orders_providers.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_stat_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/widgets/send_order_dialog.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/text_icon.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: OrdersProviders.cart,
      builder: (context, ref, cart) => _OrderScaffold(
        title: const Text('Cart'),
        order: cart,
      ),
    );
  }
}

class OrderScreen extends _OrderScaffold {
  const OrderScreen({
    super.key,
    required super.order,
  });
}

class _OrderScaffold extends StatelessWidget {
  final Widget? title;
  final OrderDto order;

  const _OrderScaffold({
    super.key,
    this.title,
    required this.order,
  });

  Widget _buildSectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      sliver: SliverToBoxAdapter(
        child: Text(text, style: textTheme.titleLarge),
      ),
    );
  }

  String _buildProductTitle(ProductOrderDto productOrder) {
    final buyers = productOrder.buyers;

    final buffer = StringBuffer();
    if (productOrder.ingredients.isNotEmpty) {
      buffer.writeln(productOrder.ingredients
          .map((e) => "${e.ingredient.title}  ${e.value * e.ingredient.maxLevel}")
          .join(", "));
    }
    if (productOrder.additions.isNotEmpty) {
      buffer.writeln(productOrder.additions.map((e) => e.addition.title).join(" - "));
    }
    buffer.write("Ordine di: ");
    buffer.write(buyers.map((e) => e.displayName).join(' - '));

    return buffer.toString();
  }

  Widget _buildOrderProducts(BuildContext context, List<ProductOrderDto> orderProducts) {
    final formats = DoofFormats.of(context);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: orderProducts.length,
        (context, index) {
          final productOrder = orderProducts[index];
          final product = productOrder.product;

          return ListTile(
            onTap: () => context.hub.push(ProductScreen(
              order: order,
              productOrder: productOrder,
              product: product,
            )),
            leading: TextIcon('${productOrder.quantity}'),
            title: Text('${formats.formatPrice(productOrder.total)} - ${product.title}'),
            subtitle: Text(_buildProductTitle(productOrder)),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => get<OrderProductsRepository>().delete(order, productOrder),
                    child: const ListTile(
                      title: Text('Delete'),
                      leading: Icon(Icons.delete),
                    ),
                  ),
                ];
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formats = DoofFormats.of(context);

    final body = AsyncViewBuilder(
      provider: OrderProductsProviders.all(order.id),
      builder: (context, ref, orderProducts) {
        if (orderProducts.isEmpty) {
          return Consumer(builder: (context, ref, _) {
            return InfoView(
              onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.products,
              title: const Text('😱 Non ci sono prodotti nel carello! 😱\n🍾 Vai al menu! 🥙'),
            );
          });
        }
        final user = ref.watch(UsersProviders.current);
        final dividedOrderProducts = orderProducts.groupListsBy((e) {
          return e.buyers.any((e) => e.id == user.id);
        });
        final myProducts = dividedOrderProducts[true] ?? const [];
        final theirProducts = dividedOrderProducts[false] ?? const [];

        return CustomScrollView(
          slivers: [
            if (myProducts.isNotEmpty) ...[
              if (theirProducts.isNotEmpty) _buildSectionTitle(context, 'My Products'),
              _buildOrderProducts(context, myProducts),
            ],
            if (theirProducts.isNotEmpty) ...[
              if (myProducts.isNotEmpty) const SliverToBoxAdapter(child: Divider()),
              _buildSectionTitle(context, 'Their Products'),
              _buildOrderProducts(context, theirProducts),
            ],
          ],
        );
      },
    );

    return AsyncViewBuilder(
      provider: OrderProductsProviders.all(order.id),
      builder: (context, ref, products) {
        return Scaffold(
          appBar: AppBar(
            title: title ?? Text(formats.formatDate(order.createdAt)),
            actions: [
              if (products.isNotEmpty)
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SendOrderDialog(
                      order: order,
                      products: products,
                    ),
                  ),
                  icon: const Icon(Icons.send),
                ),
              if (products.isNotEmpty)
                IconButton(
                  onPressed: () => context.hub.push(OrderStatScreen(orderId: order.id)),
                  icon: const Icon(Icons.attach_money),
                ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
