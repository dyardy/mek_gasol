import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'product_dto.g.dart';

@DataClass()
@JsonSerializable()
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

  factory ProductDto.fromJson(Map<String, dynamic> map) => _$ProductDtoFromJson(map);
  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
