import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

final _products = StreamProvider((ref) {
  return get<ProductsRepository>().watch();
});

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(_products);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const ProductScreen()),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: productsState.buildView(data: (products) {
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              title: Text('${product.title} - ${product.price}'),
              subtitle: Text(product.description),
            );
          },
        );
      }),
    );
  }
}

extension AsyncValueExtensions<T> on AsyncValue<T> {
  Widget buildView({
    required Widget Function(T value) data,
  }) {
    if (!hasValue) {
      return const MekProgressIndicator();
    }
    return data(requiredValue);
  }

  T get requiredValue => value as T;
}
