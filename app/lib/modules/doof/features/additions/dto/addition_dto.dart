import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'addition_dto.g.dart';

@DataClass(createFieldsClass: true)
@DtoSerializable()
class AdditionDto with _$AdditionDto {
  final String id;
  final List<String> productIds;
  final String title;
  final String description;
  final Decimal price;

  const AdditionDto({
    required this.id,
    required this.productIds,
    required this.title,
    required this.description,
    required this.price,
  });

  static const AdditionDtoFields fields = AdditionDtoFields();

  factory AdditionDto.fromJson(Map<String, dynamic> map) => _$AdditionDtoFromJson(map);
  Map<String, dynamic> toJson() => _$AdditionDtoToJson(this);
}
