import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/navigation/routes.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';

class ProductsList extends StatelessWidget {
  final List<ProductDto> products;

  const ProductsList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const InfoView(
        title: Text('🫑 Non ci sono prodotti... 🫑\n🍽 Beh, cambia categoria! 🍽'),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return ListTile(
          onTap: () => ProductRoute(product.id).go(context),
          title: Text('${DoofFormats.of(context).formatPrice(product.price)} - ${product.title}'),
          subtitle: Text(product.description),
        );
      },
    );
  }
}
