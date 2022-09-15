import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/modules/doof/features/additions/addition_order_dto.dart';
import 'package:mek_gasol/modules/doof/shared/serialization.dart';

part 'product_order_dto.g.dart';

@DataClass()
@DtoSerializable()
class ProductOrderDto with _$ProductOrderDto {
  final String userId;
  final String productId;
  final String title;
  final String description;
  final Decimal price;
  final int quantity;
  final List<AdditionOrderDto> additions;

  const ProductOrderDto({
    required this.userId,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.additions,
  });

  factory ProductOrderDto.fromJson(Map<String, dynamic> map) => _$ProductOrderDtoFromJson(map);
  Map<String, dynamic> toJson() => _$ProductOrderDtoToJson(this);
}
