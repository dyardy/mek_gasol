import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/categories/dto/category_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/products_providers.dart';
import 'package:mek_gasol/modules/doof/features/products/widgets/products_list.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: ProductsProviders.menu,
      builder: (context, ref, categorizedProducts) {
        return DefaultTabController(
          length: categorizedProducts.length,
          child: _build(context, categorizedProducts),
        );
      },
    );
  }

  Widget _build(BuildContext context, Map<CategoryDto, List<ProductDto>> categorizedProducts) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        bottom: TabBar(
          isScrollable: categorizedProducts.length > 3,
          tabs: categorizedProducts.keys.map((e) {
            return Tab(
              text: e.title,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        children: categorizedProducts.values.map((products) {
          return ProductsList(
            products: products,
          );
        }).toList(),
      ),
    );
  }
}
