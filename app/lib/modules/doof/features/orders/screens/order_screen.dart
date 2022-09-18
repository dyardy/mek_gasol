import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/orders_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/order_stat_screen.dart';
import 'package:mek_gasol/modules/doof/features/orders/screens/orders_screen.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/products_pick_screen.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/text_icon.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  late final _productsQb = QueryBloc(() {
    return get<OrderProductsRepository>().watch(widget.order);
  });

  @override
  void dispose() {
    _productsQb.close();
    super.dispose();
  }

  String _generateMessage() {
    const header = "Ciao volevo fare un ordine per domani alle 13.15 nome Kuama.\n";

    final products = _productsQb.state.data;
    final body = products.map((productOrder) => _getDisplayableOrder(productOrder)).join('\n');

    const conclusion = "Grazie mille :-)";

    return '$header\n$body\n$conclusion';
  }

  String _getDisplayableOrder(ProductOrderDto productOrder) {
    final productHeader = '-${productOrder.quantity}X ${productOrder.product.title}';

    if (productOrder.ingredients.isEmpty && productOrder.additions.isEmpty) {
      return '$productHeader\n';
    }

    var finalMessage = '$productHeader ';
    if (productOrder.ingredients.isNotEmpty) {
      finalMessage += productOrder.ingredients
          .skipWhile((value) => value.value == 0)
          .map((orderIngredient) =>
              '${orderIngredient.ingredient.title} ${orderIngredient.value * 5}') //TODO quando cambi il database aggiorna qui!
          .join(', ');
      productOrder.additions.isEmpty
          ? finalMessage += ' '
          : finalMessage +=
              ', ${productOrder.additions.map((orderAddition) => orderAddition.addition.title).join(', ')}';
    }
    return '$finalMessage\n';
  }

  Future<void> _showConfirmWhatsappDialog(String message, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "CONFERMA INVIO MESSAGGIO",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text("Preview:\n\n"),
                Text(
                  "$message\n\n",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: onConfirm,
              child: const Text("Invia", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = DoofTranslations.of(context);

    final body = QueryViewBuilder(
      bloc: _productsQb,
      builder: (context, orders) {
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final productOrder = orders[index];
            final buyers = productOrder.buyers;
            final product = productOrder.product;

            return ListTile(
              onTap: () => context.hub.push(ProductOrderScreen(
                order: widget.order,
                productOrder: productOrder,
                product: product,
              )),
              leading: TextIcon('${productOrder.quantity}'),
              title: Text('${t.formatPrice(productOrder.total)} - ${product.title}'),
              subtitle: Text(buyers.map((e) => e.displayName).join(' - ')),
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
          QueryViewBuilder(
            bloc: _productsQb,
            builder: (context, products) {
              return IconButton(
                onPressed: () => context.hub.push(OrderStatScreen(productsQb: _productsQb)),
                icon: const Icon(Icons.attach_money),
              );
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final message = _generateMessage();
          await _showConfirmWhatsappDialog(message, () async {
            const woktimePhoneNumber = '393479209560';
            await launchUrlString(
                "https://wa.me/$woktimePhoneNumber?text=${Uri.encodeQueryComponent(message)}");
            await get<OrdersRepository>().update(widget.order.copyWith(status: OrderStatus.sent));
            await context.hub.push(const OrdersScreen());
          });
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
