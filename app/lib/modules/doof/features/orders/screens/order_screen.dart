import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/products_pick_screen.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

class OrderScreen extends StatefulWidget {
  final OrderDto order;

  const OrderScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final _products = QueryBloc(() {
    return get<OrderProductsRepository>().watch(widget.order);
  });

  @override
  void dispose() {
    _products.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = DoofTranslations.of(context);

    final body = QueryViewBuilder(
      bloc: _products,
      builder: (context, orders) {
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final productOrder = orders[index];
            final user = productOrder.user;
            final product = productOrder.product;

            return ListTile(
              onTap: () => context.hub.push(ProductOrderScreen(
                order: widget.order,
                productOrder: productOrder,
                product: product,
              )),
              leading: Text('${productOrder.quantity}'),
              title: Text('${t.formatPrice(productOrder.total)} - ${product.title}'),
              subtitle: Text(user.displayName),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () =>
                          get<OrderProductsRepository>().delete(widget.order, productOrder),
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
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.formatDate(widget.order.createdAt)),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(ProductsPickScreen(order: widget.order)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: body,
    );
  }
}
