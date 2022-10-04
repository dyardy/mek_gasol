import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';

class ProductsList extends StatelessWidget {
  final List<ProductDto> products;

  const ProductsList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return QueryViewBuilder(
      bloc: get<QueryBloc<OrderDto>>(),
      builder: (context, order) => _build(context, order, products),
    );
  }

  Widget _build(BuildContext context, OrderDto order, List<ProductDto> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return ListTile(
          onTap: () => context.hub.push(ProductScreen(
            order: order,
            product: product,
          )),
          title: Text('${DoofFormats.of(context).formatPrice(product.price)} - ${product.title}'),
          subtitle: Text(product.description),
        );
      },
    );
  }
}
