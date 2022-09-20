import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/screens/product_screen.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _productsQb = QueryBloc(() {
    return get<ProductsRepository>().watch();
  });

  @override
  Widget build(BuildContext context) {
    Widget buildProducts(BuildContext context, List<ProductDto> products) {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            onTap: () => context.hub.push(ProductScreen(product: product)),
            title: Text(
                '${DoofTranslations.of(context).formatPrice(product.price)} - ${product.title}'),
            subtitle: Text(product.description),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => get<ProductsRepository>().delete(product),
                    child: const ListTile(
                      title: Text('Delete'),
                      leading: Icon(Icons.delete),
                    ),
                  )
                ];
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const ProductScreen()),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: QueryViewBuilder(
        bloc: _productsQb,
        builder: buildProducts,
      ),
    );
  }
}
