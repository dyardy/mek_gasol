import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'ingredient_dto.g.dart';

@DataClass()
@DtoSerializable()
class IngredientDto with _$IngredientDto {
  final String id;
  final List<String> productIds;
  final String title;
  final String description;
  final int minLevel;
  final int maxLevel;

  const IngredientDto({
    required this.id,
    required this.productIds,
    required this.title,
    required this.description,
    required this.minLevel,
    required this.maxLevel,
  });

  int get levels => maxLevel - minLevel;

  factory IngredientDto.fromJson(Map<String, dynamic> map) => _$IngredientDtoFromJson(map);
  Map<String, dynamic> toJson() => _$IngredientDtoToJson(this);
}
