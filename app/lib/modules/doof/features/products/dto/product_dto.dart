import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'product_dto.g.dart';

@DataClass(createFieldsClass: true)
@DtoSerializable()
class ProductDto with _$ProductDto {
  final String id;
  final String title;
  final String description;
  final Decimal price;

  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  static const ProductDtoFields fields = ProductDtoFields();

  factory ProductDto.fromJson(Map<String, dynamic> map) => _$ProductDtoFromJson(map);
  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
