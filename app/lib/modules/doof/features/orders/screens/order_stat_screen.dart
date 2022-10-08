import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/orders/orders_providers.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';
import 'package:pure_extensions/pure_extensions.dart';

class OrderStatScreen extends StatelessWidget {
  final String orderId;

  const OrderStatScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final t = DoofFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stat'),
      ),
      body: AsyncViewBuilder(
        provider: OrderProductsProviders.all(orderId),
        builder: (context, ref, products) {
          final buyers = products.expand((element) => element.buyers).toSet();
          final buyersOrder = Map.fromEntries(buyers.map((e) {
            return MapEntry(e, products.where((element) => element.buyers.contains(e)));
          }));

          return ListView(
            children: buyersOrder.generateIterable((user, products) {
              final total = products.fold(Decimal.zero, (total, product) {
                return total + product.buyerTotal;
              });

              return ListTile(
                title: Text('${t.formatPrice(total)} - ${user.displayName}'),
                subtitle: Text(products.map((e) => e.product.title).join(' - ')),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
