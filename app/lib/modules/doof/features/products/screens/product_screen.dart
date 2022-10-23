import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/users_providers.dart';
import 'package:mek_gasol/modules/doof/features/additions/additions_providers.dart';
import 'package:mek_gasol/modules/doof/features/additions/dto/addition_dto.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/ingredients_providers.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/addition_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/ingredient_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/dto/product_order_dto.dart';
import 'package:mek_gasol/modules/doof/features/orders/repositories/order_products_repository.dart';
import 'package:mek_gasol/modules/doof/features/products/dto/product_dto.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:pure_extensions/pure_extensions.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final OrderDto order;
  final ProductOrderDto? productOrder;
  final ProductDto product;

  const ProductScreen({
    super.key,
    required this.order,
    this.productOrder,
    required this.product,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final _buyersFb = FieldBloc<List<PublicUserDto>>(
    initialValue: [],
    validator: const OptionsValidation(minLength: 1),
  );
  final _quantityFb = FieldBloc<int>(initialValue: 1);
  final _additionsFb = FieldBloc<List<AdditionDto>>(initialValue: []);
  final _ingredientsFb = MapFieldBloc<String, double>();

  late final _form = ListFieldBloc(
    fieldBlocs: [_buyersFb, _quantityFb, _additionsFb, _ingredientsFb],
  );

  final _save = MutationBloc<ProductOrderDto>();

  @override
  void initState() {
    super.initState();
    _buyersFb.updateValue(widget.productOrder?.buyers ?? [ref.read(UsersProviders.current)]);
    _quantityFb.updateValue(widget.productOrder?.quantity ?? 1);
    _additionsFb.updateValue(widget.productOrder?.additions.map((e) => e.addition).toList() ?? []);

    ref.listenManual(IngredientsProviders.all(widget.product.id), (previous, next) {
      next.whenOrNull(data: (ingredients) {
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
    });
  }

  @override
  void dispose() {
    _form.close();
    _save.close();
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
            ingredient: ref
                .read(IngredientsProviders.all(widget.product.id))
                .requiredValue
                .firstWhere((e) => e.id == key),
            value: value,
          );
        }).toList(),
      );

      await get<OrderProductsRepository>().save(widget.order, productOrder);

      return productOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.observe(_save.toSource(), (state) {
      state.whenOrNull(failed: (_) {
        _form.enable();
      }, success: (product) {
        final tabBloc = ref.read(UserArea.tab.notifier);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${product.product.title} has been added to your shopping cart!'),
          action: SnackBarAction(
            onPressed: () => tabBloc.state = UserAreaTab.cart,
            label: 'Cart',
          ),
        ));
        context.pop();
      });
    });

    final t = DoofFormats.of(context);

    Widget buildBuyersField(BuildContext context, WidgetRef ref, List<PublicUserDto> users) {
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

    Widget buildAdditionsField(BuildContext context, WidgetRef ref, List<AdditionDto> additions) {
      if (additions.isEmpty) return const SizedBox.shrink();

      return FieldGroupBuilder(
        fieldBloc: _additionsFb,
        valuesCount: additions.length,
        style: const GroupStyle.flex(),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              providers: [
                AdditionsProviders.all(widget.product.id),
                IngredientsProviders.all(widget.product.id),
              ],
              formBloc: _form,
              onPressed: _onSubmit,
              builder: (context, onPressed) {
                return ElevatedButton.icon(
                  onPressed: onPressed,
                  icon:
                      widget.productOrder == null ? const Icon(Icons.add) : const Icon(Icons.edit),
                  label: Text(widget.productOrder == null ? 'Add to Cart' : 'Update Cart Item'),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            AsyncViewBuilder(
              provider: UsersProviders.all,
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
            AsyncViewBuilder(
              provider: IngredientsProviders.all(widget.product.id),
              builder: (context, ref, ingredients) {
                final fieldState = ref.react(_ingredientsFb.toSource(), when: (prev, curr) {
                  return !prev.fieldBlocs.equals(curr.fieldBlocs);
                });
                return buildIngredientsFields(context, ingredients, fieldState.fieldBlocs);
              },
            ),
            AsyncViewBuilder(
              provider: AdditionsProviders.all(widget.product.id),
              builder: buildAdditionsField,
            ),
          ],
        ),
      ),
    );
  }
}
