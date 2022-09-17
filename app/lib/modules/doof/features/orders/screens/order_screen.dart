import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/orders/controllers/order_products_controller.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
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
    return get<OrderProductsController>().watch(widget.order);
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
            final product = orders[index];

            return ListTile(
              // onTap: () => context.hub.push(OrderScreen(order: product)),
              leading: Text('${product.quantity}'),
              title: Text('${t.formatPrice(product.total)} - ${product.title}'),
              subtitle: Text(product.user.displayName),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () => get<OrderProductsController>().delete(widget.order, product),
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
            onPressed: () async {
              final data = await context.hub.push<PickedProductData>(const ProductsPickScreen());
              if (data == null) return;
              await get<OrderProductsController>()
                  .create(widget.order, data.product, data.additions);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: body,
    );
  }
}
