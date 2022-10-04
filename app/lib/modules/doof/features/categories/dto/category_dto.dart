import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'category_dto.g.dart';

@DataClass(createFieldsClass: true)
@DtoSerializable()
class CategoryDto with _$CategoryDto {
  final String id;
  final int weight;
  final String title;

  const CategoryDto({
    required this.id,
    required this.weight,
    required this.title,
  });

  static const CategoryDtoFields fields = CategoryDtoFields();

  factory CategoryDto.fromJson(Map<String, dynamic> map) => _$CategoryDtoFromJson(map);
  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
