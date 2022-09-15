import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/fields.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/button_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _titleControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _descriptionControl = FormControl<String>(
    validators: [Validators.required],
  );
  final _priceControl = FormControl<Decimal>(
    validators: [Validators.required],
  );

  late final _formControl = FormArray([_titleControl, _descriptionControl, _priceControl]);

  final _create = MutationBloc();

  void _onSubmit() async {
    if (!_formControl.valid) return;
    _formControl.markAsDisabled();

    _create.handle(() async {
      await get<ProductsRepository>().create(ProductDto(
        id: '',
        title: _titleControl.value!,
        description: _descriptionControl.value!,
        price: _priceControl.value!,
      ));
    }, onSuccess: (_) {
      context.hub.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              onPressed: _onSubmit,
              mutationBloc: _create,
              formControl: _formControl,
              builder: (context, onPressed) {
                return ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Create'),
                );
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          AppTextField(
            formControl: _titleControl,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          AppTextField(
            formControl: _descriptionControl,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          AppDecimalField(
            formControl: _priceControl,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
        ],
      ),
    );
  }
}
