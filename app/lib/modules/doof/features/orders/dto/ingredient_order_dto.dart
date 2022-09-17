import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/features/ingredients/dto/ingredient_dto.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'ingredient_order_dto.g.dart';

@DataClass()
@DtoSerializable()
class IngredientOrderDto with _$IngredientOrderDto {
  final IngredientDto ingredient;
  final double value;

  const IngredientOrderDto({
    required this.ingredient,
    required this.value,
  });

  factory IngredientOrderDto.fromJson(Map<String, dynamic> map) =>
      _$IngredientOrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$IngredientOrderDtoToJson(this);
}
