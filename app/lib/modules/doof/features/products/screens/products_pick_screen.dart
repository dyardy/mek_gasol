import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/additions/repositories/additions_repository.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/repositories/ingredients_repository.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/addition_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/ingredient_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/features/products/repositories/products_repository.dart';
import 'package:mek_gasol/modules/doof/shared/doof_transaltions.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:pure_extensions/pure_extensions.dart';

class ProductsPickScreen extends StatefulWidget {
  final OrderDto order;

  const ProductsPickScreen({
    super.key,
    required this.order,
  });

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
            onTap: () => context.hub.push(ProductOrderScreen(
              order: widget.order,
              product: product,
            )),
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

class ProductOrderScreen extends StatefulWidget {
  final OrderDto order;
  final ProductOrderDto? productOrder;
  final ProductDto product;

  const ProductOrderScreen({
    super.key,
    required this.order,
    this.productOrder,
    required this.product,
  });

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  final _usersQb = QueryBloc(() {
    return get<UsersRepository>().watchAll();
  });
  late final _additionsQb = QueryBloc(() {
    return get<AdditionsRepository>().watch(widget.product);
  });
  late final _ingredientsQb = QueryBloc(() {
    return get<IngredientsRepository>().watch(widget.product);
  });

  final _buyersFb = FieldBloc<List<PublicUserDto>>(initialValue: []);
  final _quantityFb = FieldBloc<int>(initialValue: 1);
  final _additionsFb = FieldBloc<List<AdditionDto>>(initialValue: []);
  final _ingredientsFb = MapFieldBloc<String, double>();

  late final _form = ListFieldBloc(
    fieldBlocs: [_buyersFb, _quantityFb, _additionsFb, _ingredientsFb],
  );

  final _save = MutationBloc();

  @override
  void initState() {
    super.initState();
    _buyersFb.updateValue(widget.productOrder?.buyers ?? [get()]);
    _quantityFb.updateValue(widget.productOrder?.quantity ?? 1);
    _additionsFb.updateValue(widget.productOrder?.additions.map((e) => e.addition).toList() ?? []);
    _ingredientsQb.stream.map((state) => state.dataOrNull).whereNotNull().listen((ingredients) {
      _ingredientsFb.updateFieldBlocs({
        for (final ingredient in ingredients)
          ingredient.id: FieldBloc(
            initialValue: widget.productOrder?.ingredients
                    .firstWhereOrNull((e) => e.ingredient.id == ingredient.id)
                    ?.value ??
                0.0,
          ),
      });
    });
  }

  @override
  void dispose() {
    _additionsQb.close();
    _ingredientsQb.close();
    _form.close();
    super.dispose();
  }

  void _onSubmit() {
    _save.handle(() async {
      _form.disable();

      final productOrder = ProductOrderDto(
        id: widget.productOrder?.id ?? '',
        buyers: _buyersFb.state.value,
        product: widget.productOrder?.product ?? widget.product,
        quantity: _quantityFb.state.value,
        additions: _additionsFb.state.value.map((e) {
          return AdditionOrderDto(
            addition: e,
          );
        }).toList(),
        ingredients: _ingredientsFb.state.value.generateIterable((key, value) {
          return IngredientOrderDto(
            ingredient: _ingredientsQb.state.data.firstWhere((e) => e.id == key),
            value: value,
          );
        }).toList(),
      );

      await get<OrderProductsRepository>().save(widget.order, productOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = DoofTranslations.of(context);

    Widget buildBuyersField(BuildContext context, List<PublicUserDto> users) {
      return FieldChipsInput<PublicUserDto>(
        fieldBloc: _buyersFb,
        decoration: const InputDecoration(
          labelText: 'Buyers',
        ),
        findSuggestions: (query) {
          return users.where((user) {
            return user.displayName.toLowerCase().contains(query.toLowerCase());
          }).toList();
        },
        suggestionBuilder: (context, suggestion) => ListTile(title: Text(suggestion.displayName)),
        chipBuilder: (context, state, value) {
          return Chip(
            onDeleted: () => state.deleteChip(value),
            label: Text(value.displayName),
          );
        },
      );
    }

    Widget buildIngredientsFields(
      BuildContext context,
      List<IngredientDto> ingredients,
      Map<String, FieldBlocRule<double>> fieldBlocs,
    ) {
      return Column(
        children: fieldBlocs.generateIterable((ingredientId, fieldBloc) {
          final ingredient = ingredients.firstWhereOrNull((e) => e.id == ingredientId);
          if (ingredient == null) return const SizedBox.shrink();

          final divisions = ingredient.levels;
          return FieldSlider(
            fieldBloc: fieldBloc,
            min: 0.0,
            max: 1.0,
            divisions: divisions,
            decoration: InputDecoration(
              labelText: ingredient.title,
            ),
            labelBuilder: (value) => (divisions * value).toStringAsFixed(0),
          );
        }).toList(),
      );
    }

    Widget buildAdditionsField(BuildContext context, List<AdditionDto> additions) {
      if (additions.isEmpty) return const SizedBox.shrink();

      return FieldGroupBuilder(
        fieldBloc: _additionsFb,
        valuesCount: additions.length,
        style: const GroupStyle.list(),
        decoration: const InputDecoration(
          labelText: 'Additions',
        ),
        valueBuilder: (state, index) {
          final value = additions[index];

          return CheckboxListTile(
            value: state.value.contains(value),
            onChanged: state.widgetSelectHandler(_additionsFb, value),
            title: Text('${t.formatPrice(value.price)} - ${value.title}'),
            subtitle: Text(value.description),
          );
        },
      );
    }

    Widget current = Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              queryBlocs: {_additionsQb, _ingredientsQb},
              formBloc: _form,
              onPressed: _onSubmit,
              builder: (context, onPressed) {
                return ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.check),
                  label: Text(widget.productOrder == null ? 'Select' : 'Update'),
                );
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            QueryViewBuilder(
              bloc: _usersQb,
              builder: buildBuyersField,
            ),
            FieldDropdown(
              fieldBloc: _quantityFb,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              items: [
                for (var i = 1; i <= 8; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text('$i'),
                  ),
              ],
            ),
            QueryViewBuilder(
              bloc: _ingredientsQb,
              builder: (context, ingredients) {
                return BlocBuilder(
                  bloc: _ingredientsFb,
                  buildWhen: (prev, curr) => !prev.fieldBlocs.equals(curr.fieldBlocs),
                  builder: (context, control) {
                    return buildIngredientsFields(context, ingredients, control.fieldBlocs);
                  },
                );
              },
            ),
            Expanded(
              child: QueryViewBuilder(
                bloc: _additionsQb,
                builder: buildAdditionsField,
              ),
            ),
          ],
        ),
      ),
    );
    current = BlocListener(
      bloc: _save,
      listener: (context, state) {
        state.whenOrNull(failed: (_) {
          _form.enable();
        }, success: (_) {
          context.hub.pop();
        });
      },
      child: current,
    );
    return current;
  }
}
