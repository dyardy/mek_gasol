import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/fields.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/button_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ProductScreen extends StatefulWidget {
  final ProductDto? product;

  const ProductScreen({
    super.key,
    this.product,
  });

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

  final _mutationBloc = MutationBloc();

  @override
  void initState() {
    super.initState();
    _titleControl.updateValue(widget.product?.title);
    _descriptionControl.updateValue(widget.product?.description);
    _priceControl.updateValue(widget.product?.price);
  }

  void _onSubmit() async {
    if (!_formControl.valid) return;
    _formControl.markAsDisabled();

    _mutationBloc.handle(() async {
      await get<ProductsRepository>().save(ProductDto(
        id: widget.product?.id ?? '',
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
              mutationBloc: _mutationBloc,
              formControl: _formControl,
              builder: (context, onPressed) {
                return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(widget.product == null ? 'Create' : 'Update'),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppTextField(
                formControl: _titleControl,
                maxLines: 2,
                minLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              AppTextField(
                formControl: _descriptionControl,
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.text,
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
        ),
      ),
    );
  }
}
