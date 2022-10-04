import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/categories/dto/category_dto.dart';
import 'package:mek_gasol/modules/doof/features/categories/repositories/categories_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/widgets/products_list.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:rxdart/rxdart.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _categorizedProductsQb = QueryBloc(() {
    return Rx.combineLatest2(get<CategoriesRepository>().watch(), get<ProductsRepository>().watch(),
        (categories, products) {
      return products.groupListsBy((product) => product.categoryId).map((key, value) {
        final category = categories.firstWhere((e) => e.id == key);
        return MapEntry(category, value);
      });
    });
  });

  @override
  void dispose() {
    _categorizedProductsQb.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryViewBuilder(
      bloc: _categorizedProductsQb,
      builder: (context, categorizedProducts) {
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
