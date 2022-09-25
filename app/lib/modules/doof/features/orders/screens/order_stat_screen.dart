import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:pure_extensions/pure_extensions.dart';

class OrderStatScreen extends StatelessWidget {
  final QueryBloc<List<ProductOrderDto>> productsQb;

  const OrderStatScreen({
    super.key,
    required this.productsQb,
  });

  @override
  Widget build(BuildContext context) {
    final t = DoofFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stat'),
      ),
      body: QueryViewBuilder(
        bloc: productsQb,
        builder: (context, products) {
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
