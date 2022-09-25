import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _products = QueryBloc(() {
    return get<ProductsRepository>().watch();
  });

  @override
  void dispose() {
    _products.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBody(BuildContext context, OrderDto order, List<ProductDto> products) {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            onTap: () => context.hub.push(ProductScreen(
              order: order,
              product: product,
            )),
            title: Text(
                '${DoofTranslations.of(context).formatPrice(product.price)} - ${product.title}'),
            subtitle: Text(product.description),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: QueryViewBuilder(
        bloc: QueryBloc.combine2(get<QueryBloc<OrderDto>>(), _products),
        builder: (context, vls) => buildBody(context, vls.item1, vls.item2),
      ),
    );
  }
}
