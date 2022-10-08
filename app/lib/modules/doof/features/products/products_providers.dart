import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/features/categories/categories_providers.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class ProductsProviders {
  static final all = StreamProvider((ref) {
    return get<ProductsRepository>().watch();
  });

  static final menu = FutureProvider((ref) async {
    final categories = await ref.watch(CategoriesProviders.all.future);
    final products = await ref.watch(ProductsProviders.all.future);

    return categories.map((category) {
      return MapEntry(category, products.where((e) => e.categoryId == category.id).toList());
    }).toMap();
  });
}
