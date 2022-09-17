import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PickedProductData {
  final ProductDto product;
  final List<AdditionDto> additions;

  const PickedProductData({
    required this.product,
    required this.additions,
  });
}

class ProductsPickScreen extends StatefulWidget {
  const ProductsPickScreen({super.key});

  @override
  State<ProductsPickScreen> createState() => _ProductsPickScreenState();
}

class _ProductsPickScreenState extends State<ProductsPickScreen> {
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
    Widget buildBody(BuildContext context, List<ProductDto> products) {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            onTap: () async {
              final additions = await showDialog<List<AdditionDto>>(
                context: context,
                builder: (context) => AdditionsPickDialog(product: product),
              );
              if (additions == null) return;
              context.hub.pop(PickedProductData(
                product: product,
                additions: additions,
              ));
            },
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
      body: QueryViewBuilder(bloc: _products, builder: buildBody),
    );
  }
}

class AdditionsPickDialog extends StatefulWidget {
  final ProductDto product;
  final List<AdditionDto> additions;

  const AdditionsPickDialog({
    super.key,
    required this.product,
    this.additions = const [],
  });

  @override
  State<AdditionsPickDialog> createState() => _AdditionsPickDialogState();
}

class _AdditionsPickDialogState extends State<AdditionsPickDialog> {
  final _additions = QueryBloc(() {
    return get<AdditionsRepository>().watch();
  });

  final _additionsControl = FormControl<List<AdditionDto>>(value: []);

  @override
  void initState() {
    super.initState();
    _additionsControl.updateValue(widget.additions);
  }

  @override
  void dispose() {
    _additions.close();
    _additionsControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = DoofTranslations.of(context);

    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      title: Text(widget.product.title),
      content: QueryViewBuilder(
        bloc: _additions,
        builder: (context, additions) {
          return ReactiveFormField<List<AdditionDto>, List<AdditionDto>>(
            formControl: _additionsControl,
            builder: (state) {
              return ListView.builder(
                itemCount: additions.length,
                itemBuilder: (context, index) {
                  final addition = additions[index];
                  final value = state.value!;

                  return CheckboxListTile(
                    value: value.contains(addition),
                    onChanged: (isChecked) {
                      if (isChecked!) {
                        state.didChange([...value, addition]);
                      } else {
                        state.didChange([...value]..remove(addition));
                      }
                    },
                    title: Text('${t.formatPrice(addition.price)} - ${addition.title}'),
                    subtitle: Text(addition.description),
                  );
                },
              );
            },
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => context.hub.pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => context.hub.pop(_additionsControl.value),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
