import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/hub.dart';

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
  final _titleControl = FieldBloc<String>(
    initialValue: '',
    validators: [const TextValidation()],
  );
  final _descriptionControl = FieldBloc<String>(
    initialValue: '',
    validators: [const TextValidation()],
  );
  final _priceControl = FieldBloc<Decimal?>(
    initialValue: null,
    validators: [const RequiredValidation()],
  );

  late final _formControl = ListFieldBloc(
    fieldBlocs: [_titleControl, _descriptionControl, _priceControl],
  );

  final _mutationBloc = MutationBloc();

  @override
  void initState() {
    super.initState();
    _titleControl.updateValue(widget.product?.title);
    _descriptionControl.updateValue(widget.product?.description);
    _priceControl.updateValue(widget.product?.price);
  }

  void _onSubmit() {
    _mutationBloc.handle(() async {
      _formControl.disable();

      await get<ProductsRepository>().save(ProductDto(
        id: widget.product?.id ?? '',
        title: _titleControl.state.value,
        description: _descriptionControl.state.value,
        price: _priceControl.state.value!,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget current = Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              onPressed: _onSubmit,
              mutationBlocs: {_mutationBloc},
              formBloc: _formControl,
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
              FieldText(
                fieldBloc: _titleControl,
                converter: FieldConvert.text,
                maxLines: 2,
                minLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              FieldText(
                fieldBloc: _descriptionControl,
                converter: FieldConvert.text,
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              FieldText(
                fieldBloc: _priceControl,
                converter: FieldConvert.decimal,
                type: const TextFieldType.numeric(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
            ],
          ),
        ),
      ),
    );
    current = BlocListener(
      bloc: _mutationBloc,
      listener: (context, state) {
        state.whenOrNull(failed: (_) {
          _formControl.enable();
        }, success: (_) {
          context.hub.pop();
        });
      },
      child: current,
    );
    return current;
  }
}
