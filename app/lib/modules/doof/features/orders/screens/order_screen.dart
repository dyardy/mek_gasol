import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_stat_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/widgets/send_order_dialog.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/text_icon.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QueryViewBuilder(
      bloc: get<QueryBloc<OrderDto>>(),
      builder: (context, cart) => _OrderScaffold(
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

class _OrderScaffold extends StatefulWidget {
  final Widget? title;
  final OrderDto order;

  const _OrderScaffold({
    super.key,
    this.title,
    required this.order,
  });

  @override
  State<_OrderScaffold> createState() => _OrderScaffoldState();
}

class _OrderScaffoldState extends State<_OrderScaffold> {
  late QueryBloc<List<ProductOrderDto>> _productsQb;

  @override
  void initState() {
    super.initState();
    _initProducts();
  }

  @override
  void didUpdateWidget(covariant _OrderScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.order.id != oldWidget.order.id) {
      _productsQb.close();
      _initProducts();
    }
  }

  @override
  void dispose() {
    _productsQb.close();
    super.dispose();
  }

  void _initProducts() {
    _productsQb = QueryBloc(() {
      return get<OrderProductsRepository>().watch(widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formats = DoofFormats.of(context);

    final body = QueryViewBuilder(
      bloc: _productsQb,
      builder: (context, orderProducts) {
        if (orderProducts.isEmpty) {
          return InfoView(
            onTap: () => get<ValueBloc<UserAreaTab>>().emit(UserAreaTab.products),
            title: const Text('😱 Non ci sono prodotti nel carello! 😱\n🍾 Vai al menu! 🥙'),
          );
        }

        return ListView.builder(
          itemCount: orderProducts.length,
          itemBuilder: (context, index) {
            final productOrder = orderProducts[index];
            final buyers = productOrder.buyers;
            final product = productOrder.product;

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

            return ListTile(
              onTap: () => context.hub.push(ProductScreen(
                order: widget.order,
                productOrder: productOrder,
                product: product,
              )),
              leading: TextIcon('${productOrder.quantity}'),
              title: Text('${formats.formatPrice(productOrder.total)} - ${product.title}'),
              subtitle: Text(buffer.toString()),
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

    return QueryViewBuilder(
      bloc: _productsQb,
      builder: (context, products) {
        return Scaffold(
          appBar: AppBar(
            title: widget.title ?? Text(formats.formatDate(widget.order.createdAt)),
            actions: [
              if (products.isNotEmpty)
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => SendOrderDialog(
                      order: widget.order,
                      products: products,
                    ),
                  ),
                  icon: const Icon(Icons.send),
                ),
              if (products.isNotEmpty)
                IconButton(
                  onPressed: () => context.hub.push(OrderStatScreen(productsQb: _productsQb)),
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
